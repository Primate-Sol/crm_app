class UserRegistrationService
  Result = Struct.new(:success?, :user, :errors)

  def self.register(params)
    file_path = Rails.root.join("data", "users.json")
    users = User.from_json(file_path)

    user = User.new(
      name: params[:name].to_s.strip,
      email: params[:email].to_s.strip.downcase
    )
    user.password = params[:password].to_s

    Rails.logger.debug "Processing user registration attempt for: #{user.email}"

    if users.any? { |u| u.email.downcase == user.email }
      return Result.new(false, user, ["Email already registered"])
    end

    unless user.valid?
      Rails.logger.warn "User registration failed for #{user.email}: #{user.errors.full_messages.join(', ')}"
      return Result.new(false, user, user.errors.full_messages)
    end

    users << user
    User.save_all(users, file_path)
    Rails.logger.info "New user registered: #{user.email} (ID: #{user.id})"

    Result.new(true, user, [])
  end
end
