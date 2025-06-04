class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  EMAIL_FORMAT = /\A[^@\s]+@[^@\s]+\z/ # Validates email contains exactly one @ symbol and no whitespace

  def new
    # Render registration form
  end

  def create
    file_path = Rails.root.join("data", "users.json")
    users = User.from_json(file_path)

    name = registration_params[:name].to_s.strip
    email = registration_params[:email].to_s.strip.downcase
    password = registration_params[:password].to_s
    errors = []

    Rails.logger.debug "Processing user registration attempt for: #{email}"

    # Input presence checks
    errors << "Name cannot be blank" if name.empty?
    errors << "Email cannot be blank" if email.empty?
    errors << "Password cannot be blank" if password.empty?

    # Email format validation
    unless email.match?(EMAIL_FORMAT)
      errors << "Email format is invalid"
    end

    # Password complexity validation
    errors << "Password must be at least 8 characters" unless password.length >= 8
    errors << "Password must include at least one lowercase letter" unless password.match(/[a-z]/)
    errors << "Password must include at least one uppercase letter" unless password.match(/[A-Z]/)
    errors << "Password must include at least one number" unless password.match(/\d/)
    errors << "Password must include at least one special character" unless password.match(/[^A-Za-z0-9]/)

    # Duplicate email check
    if users.any? { |u| u.email.downcase == email }
      errors << "Email already registered"
    end

    if errors.any?
      Rails.logger.warn "User registration failed for #{email}: #{errors.join(', ')}"
      flash[:alert] = errors.join(". ") + "."
      redirect_to register_path
      return
    end

    user = User.new(name: name, email: email)
    user.password = password
    users << user

    User.save_all(users, file_path)
    session[:user_id] = user.id
    Rails.logger.info "New user registered: #{email} (ID: #{user.id})"
    redirect_to clients_path, notice: "Registration successful!"
  end

  private

  def registration_params
    params.require(:user).permit(:name, :email, :password)
  end
end
