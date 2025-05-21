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

    user = User.new(name: params[:name], email: params[:email])
    user.password = params[:password]
    users << user

    User.save_all(users, file_path)
    session[:user_id] = user.id
    redirect_to clients_path, notice: "Registration successful!"
  end
end
