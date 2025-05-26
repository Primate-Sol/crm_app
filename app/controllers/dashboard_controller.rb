class DashboardController < ApplicationController
  def index
    # Load counts for dashboard using current_user.id
    @client_count = JsonStorage.read("clients.json").count { |c| c["user_id"] == current_user.id }
    @task_count   = JsonStorage.read("tasks.json").count   { |t| t["user_id"] == current_user.id }

    # Future expansions can include:
    # @project_count = JsonStorage.read("projects.json").count { |p| p["user_id"] == current_user.id }
    # @invoice_count = JsonStorage.read("invoices.json").count { |i| i["user_id"] == current_user.id }
    # @ticket_count  = JsonStorage.read("tickets.json").count  { |t| t["user_id"] == current_user.id }
  end
end
