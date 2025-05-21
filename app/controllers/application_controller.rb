class ApplicationController < ActionController::Base
  before_action :require_login

  private

  def require_login
    unless session[:user_id] || allowed_paths?
      redirect_to login_path
    end
  end

  def allowed_paths?
    # Allow access to login and registration pages
    (controller_name == "sessions" && %w[new create].include?(action_name)) ||
    (controller_name == "users" && %w[new create].include?(action_name))
  end

  def current_user
    return unless session[:user_id]
    @current_user ||= User.find_by_id(session[:user_id])
  end
  helper_method :current_user
end
