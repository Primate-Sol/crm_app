class DashboardController < ApplicationController
  before_action :require_login

  def index
    # Get the current user's ID (assuming current_user returns a Hash)
    user_id = current_user["id"]

    @client_count = JsonStorage.read("clients.json").count { |c| c["user_id"] == user_id }
    @task_count   = JsonStorage.read("tasks.json").count   { |t| t["user_id"] == user_id }

    # Future expansions
    # @project_count = JsonStorage.read("projects.json").count { |p| p["user_id"] == user_id }
    # @invoice_count = JsonStorage.read("invoices.json").count { |i| i["user_id"] == user_id }
    # @ticket_count  = JsonStorage.read("tickets.json").count  { |t| t["user_id"] == user_id }
  end

  private

  def require_login
    unless current_user && current_user["id"]
      redirect_to login_path, alert: "Please log in to access the dashboard."
    end
  end

  def current_user
    @current_user ||= begin
      users = JsonStorage.read("users.json")
      users.find { |u| u["id"] == session[:user_id] }
    end
  end
end
