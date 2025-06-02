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
    errors = []

    # Password Complexity Checks
    errors << "must be at least 8 characters" unless password.length >= 8
    errors << "must include at least one lowercase letter" unless password.match(/[a-z]/)
    errors << "must include at least one uppercase letter" unless password.match(/[A-Z]/)
    errors << "must include at least one number" unless password.match(/\d/)
    errors << "must include at least one special character" unless password.match(/[^A-Za-z0-9]/)

    if errors.any?
      flash[:alert] = "Password #{errors.join(', ')}."
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
end
