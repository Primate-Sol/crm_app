Rails.application.routes.draw do
  root "clients#index"

  resources :clients

  # Session routes for login/logout
  get    "/login",  to: "sessions#new",     as: :login
  post   "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout

  # User registration routes
  get  "/register", to: "users#new",    as: :register
  post "/register", to: "users#create"

  # You can add other resources like tickets, tasks, invoices later here
end

