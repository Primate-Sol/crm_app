class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  MAX_LOGIN_ATTEMPTS = 5
  LOCKOUT_TIME = 15.minutes

  def new
    # Renders the login form (app/views/sessions/new.html.erb)
  end

  def create
    email = params[:email].downcase.strip
    file_path = Rails.root.join("data", "users.json")
    users = User.from_json(file_path)
    user = users.find { |u| u.email.downcase == email }

    if locked_out?(email)
      flash[:alert] = "Account temporarily locked due to too many failed login attempts. Try again later."
      redirect_to login_path
      return
    end

    if user && user.authenticate(params[:password])
      reset_attempts(email)
      session[:user_id] = user.id
      Rails.logger.debug "Logged in: #{user.email}, session user_id: #{session[:user_id]}"
      respond_to do |format|
        format.html { redirect_to dashboard_path, notice: "Logged in!" }
        format.turbo_stream { redirect_to dashboard_path }
      end
    else
      increment_attempts(email)
      flash[:alert] = "Invalid email or password"
      respond_to do |format|
        format.html { redirect_to login_path }
        format.turbo_stream { redirect_to login_path }
      end
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to login_path, notice: "Logged out!"
  end

  private

  def cache_key_for(email)
    "login_attempts:#{email}"
  end

  def locked_out?(email)
    attempts = Rails.cache.read(cache_key_for(email)) || { count: 0, locked_until: nil }

    if attempts[:locked_until] && Time.current < attempts[:locked_until]
      true
    else
      false
    end
  end

  def increment_attempts(email)
    key = cache_key_for(email)
    attempts = Rails.cache.read(key) || { count: 0, locked_until: nil }
    attempts[:count] += 1

    if attempts[:count] >= MAX_LOGIN_ATTEMPTS
      attempts[:locked_until] = Time.current + LOCKOUT_TIME
    end

    Rails.cache.write(key, attempts, expires_in: 1.hour)
  end

  def reset_attempts(email)
    Rails.cache.delete(cache_key_for(email))
  end
end
