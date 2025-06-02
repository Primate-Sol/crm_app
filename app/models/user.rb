class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    # Render registration form
  end

  def create
    file_path = Rails.root.join("data", "users.json")
    users = User.from_json(file_path)

    if users.any? { |u| u.email == params[:email] }
      flash[:alert] = "Email already registered"
      redirect_to register_path
      return
    end

    password = params[:password]

    unless valid_password?(password)
      flash[:alert] = "Password must be at least 8 characters and include an uppercase letter, a lowercase letter, a number, and a special character."
      redirect_to register_path
      return
    end

    user = User.new(name: params[:name], email: params[:email])
    user.password = password
    users << user

    User.save_all(users, file_path)
    session[:user_id] = user.id
    redirect_to clients_path, notice: "Registration successful!"
  end

  private

  def valid_password?(password)
    password.length >= 8 &&
      password.match(/[A-Z]/) &&
      password.match(/[a-z]/) &&
      password.match(/[0-9]/) &&
      password.match(/[^A-Za-z0-9]/)
  end
end
