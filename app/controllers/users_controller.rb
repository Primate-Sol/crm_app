def create
  file_path = Rails.root.join("data", "users.json")
  users = User.from_json(file_path)

  name = user_params[:name].to_s.strip
  email = user_params[:email].to_s.strip.downcase
  password = user_params[:password].to_s

  Rails.logger.info "Attempting registration for email: #{email}"

  errors = validate_inputs(name, email, password, users)

  if errors.any?
    Rails.logger.warn "Registration failed for #{email}: #{errors.join(', ')}"
    flash[:alert] = errors.join(". ") + "."
    redirect_to register_path and return
  end

  user = User.new(name: name, email: email)
  user.password = password
  users << user

  User.save_all(users, file_path)
  session[:user_id] = user.id

  Rails.logger.info "Registration successful for user ID #{user.id}, email: #{user.email}"
  redirect_to clients_path, notice: "Registration successful!"
end

private

# Whitelists and requires necessary parameters
def user_params
  params.require(:user).permit(:name, :email, :password)
end

# Validates presence, format, and uniqueness
def validate_inputs(name, email, password, users)
  errors = []

  errors << "Name cannot be blank" if name.empty?
  errors << "Email cannot be blank" if email.empty?
  errors << "Password cannot be blank" if password.empty?

  unless email.match?(/\A[^@\s]+@[^@\s]+\z/)
    errors << "Email format is invalid"
  end

  if users.any? { |u| u.email.downcase.strip == email }
    errors << "Email already registered"
  end

  if password.length < 8
    errors << "Password must be at least 8 characters"
  end
  errors << "Password must include at least one lowercase letter" unless password.match(/[a-z]/)
  errors << "Password must include at least one uppercase letter" unless password.match(/[A-Z]/)
  errors << "Password must include at least one number" unless password.match(/\d/)
  errors << "Password must include at least one special character" unless password.match(/[^A-Za-z0-9]/)

  errors
end
