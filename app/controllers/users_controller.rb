def create
  file_path = Rails.root.join("data", "users.json")
  users = User.from_json(file_path)

  name = params[:name].to_s.strip
  email = params[:email].to_s.strip.downcase
  password = params[:password].to_s
  errors = []

  # Basic input presence checks
  errors << "Name cannot be blank" if name.empty?
  errors << "Email cannot be blank" if email.empty?
  errors << "Password cannot be blank" if password.empty?

  # Email format validation
  unless email.match?(/\A[^@\s]+@[^@\s]+\z/)
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
    flash[:alert] = errors.join(". ") + "."
    redirect_to register_path
    return
  end

  user = User.new(name: name, email: email)
  user.password = password
  users << user

  User.save_all(users, file_path)
  session[:user_id] = user.id
  redirect_to clients_path, notice: "Registration successful!"
end
