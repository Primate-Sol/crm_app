class CalendarController < ApplicationController
  before_action :require_login

  def index
    respond_to do |format|
      format.html
      format.json do
        events = JsonStorage.read("events.json").select do |e|
          e["user_id"] == current_user.id
        end

        render json: events.map { |event|
          {
            id: event["id"],
            title: event["title"],
            start: event["start"],
            end: event["end"]
          }
        }
      end
    end
  end
end
