class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    # render registration form
  end

  def create
    result = UserRegistrationService.register(registration_params)

    if result.success?
      session[:user_id] = result.user.id
      redirect_to clients_path, notice: "Registration successful!"
    else
      flash[:alert] = result.errors.join(". ") + "."
      redirect_to register_path
    end
  end

  private

  def registration_params
    params.require(:user).permit(:name, :email, :password)
  end
end
