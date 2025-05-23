class TasksController < ApplicationController
  FILE = "tasks.json"

  def index
    all_tasks = JsonStorage.read(FILE)
    @tasks = all_tasks.select { |t| t["user_id"] == session[:user_id] }
  end

  def show
    task = JsonStorage.find(FILE, params[:id].to_i)
    if task && task["user_id"] == session[:user_id]
      @task = task
    else
      redirect_to tasks_path, alert: "Access denied."
    end
  end

  def new
    @task = {}
  end

  def create
    @task = {
      "user_id" => session[:user_id],
      "title" => params[:title],
      "description" => params[:description],
      "status" => params[:status] || "pending",
      "due_date" => params[:due_date]
    }
    JsonStorage.save(FILE, @task)
    redirect_to tasks_path, notice: "Task created."
  end

  def edit
    task = JsonStorage.find(FILE, params[:id].to_i)
    if task && task["user_id"] == session[:user_id]
      @task = task
    else
      redirect_to tasks_path, alert: "Access denied."
    end
  end

  def update
    task = JsonStorage.find(FILE, params[:id].to_i)
    if task && task["user_id"] == session[:user_id]
      updated = {
        "user_id" => session[:user_id],
        "title" => params[:title],
        "description" => params[:description],
        "status" => params[:status],
        "due_date" => params[:due_date]
      }
      JsonStorage.update(FILE, params[:id].to_i, updated)
      redirect_to tasks_path, notice: "Task updated."
    else
      redirect_to tasks_path, alert: "Access denied."
    end
  end

  def destroy
    task = JsonStorage.find(FILE, params[:id].to_i)
    if task && task["user_id"] == session[:user_id]
      JsonStorage.delete(FILE, params[:id].to_i)
      redirect_to tasks_path, notice: "Task deleted."
    else
      redirect_to tasks_path, alert: "Access denied."
    end
  end
end
