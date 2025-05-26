class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    # Renders the login form (app/views/sessions/new.html.erb)
  end

  def create
    file_path = Rails.root.join("data", "users.json")
    users = User.from_json(file_path)

    user = users.find { |u| u.email == params[:email] }

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      Rails.logger.debug "Logged in: #{user.email}, session user_id: #{session[:user_id]}"
      respond_to do |format|
        format.html { redirect_to dashboard_path, notice: "Logged in!" }
        format.turbo_stream { redirect_to dashboard_path }
      end
    else
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
end
