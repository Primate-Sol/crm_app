class ClientsController < ApplicationController
  FILE = "clients.json"

  def index
    # Load all clients, then filter for only the logged-in user's clients
    all_clients = JsonStorage.read(FILE)
    @clients = all_clients.select { |c| c["user_id"] == session[:user_id] }
  end

  def show
    client = JsonStorage.find(FILE, params[:id].to_i)
    if client && client["user_id"] == session[:user_id]
      @client = client
    else
      redirect_to clients_path, alert: "Access denied."
    end
  end

  def new
    @client = {}
  end

  def create
    @client = {
      "user_id" => session[:user_id],
      "name" => params[:name],
      "email" => params[:email],
      "phone" => params[:phone]
    }
    JsonStorage.save(FILE, @client)
    redirect_to clients_path
  end

  def edit
    client = JsonStorage.find(FILE, params[:id].to_i)
    if client && client["user_id"] == session[:user_id]
      @client = client
    else
      redirect_to clients_path, alert: "Access denied."
    end
  end

  def update
    client = JsonStorage.find(FILE, params[:id].to_i)
    if client && client["user_id"] == session[:user_id]
      updated = {
        "user_id" => session[:user_id],  # keep the user_id consistent
        "name" => params[:name],
        "email" => params[:email],
        "phone" => params[:phone]
      }
      JsonStorage.update(FILE, params[:id].to_i, updated)
      redirect_to clients_path
    else
      redirect_to clients_path, alert: "Access denied."
    end
  end

  def destroy
    client = JsonStorage.find(FILE, params[:id].to_i)
    if client && client["user_id"] == session[:user_id]
      JsonStorage.delete(FILE, params[:id].to_i)
      redirect_to clients_path, notice: "Client deleted."
    else
      redirect_to clients_path, alert: "Access denied."
    end
  end
end

