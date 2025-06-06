class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    # Renders the user registration form
  end

  def create
    Rails.logger.info "User registration attempt for email: #{registration_params[:email]}"

    result = UserRegistrationService.register(registration_params)

    if result.success?
      Rails.logger.info "User registration successful for email: #{registration_params[:email]}"
      session[:user_id] = result.user.id
      redirect_to clients_path, notice: "Registration successful!"
    else
      Rails.logger.warn "User registration failed for email: #{registration_params[:email]}. Errors: #{result.errors.join(', ')}"
      flash[:alert] = result.errors.join(". ") + "."
      redirect_to register_path
    end
  end

  private

  # Protects against mass assignment vulnerabilities by explicitly
  # defining which parameters are allowed for user creation
  def registration_params
    params.require(:user).permit(:name, :email, :password)
  end
end
