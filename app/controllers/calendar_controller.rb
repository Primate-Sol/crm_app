class CalendarController < ApplicationController
  before_action :require_login

  def index
    # This renders calendar/index.html.erb
    # You can preload user-specific events here in the future, like:
    # @events = JsonStorage.read("events.json").select { |e| e["user_id"] == current_user["id"] }
  end
end
