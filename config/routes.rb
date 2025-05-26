Rails.application.routes.draw do
  # get 'dashboard/index'
  # root "clients#index"
  root "dashboard#index"
  get "/dashboard", to: "dashboard#index", as: :dashboard

  # calendar
  get '/calendar', to: 'calendar#index'
  
  resources :clients
  resources :tasks
  resources :projects

  #Session routes for login/logout
  get    "/login",  to: "sessions#new",     as: :login
  post   "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout

  # User registration routes
  get  "/register", to: "users#new",    as: :register
  post "/register", to: "users#create"

  # You can add other resources like tickets, tasks, invoices later here
end

