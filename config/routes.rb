Rails.application.routes.draw do
  root "landing#index"
  get "login", to: 'login#new'
  post "login", to: 'login#create'
  # get "logout", to: 'login#destroy'
  delete "logout", to: 'login#destroy'
  resources :user
  get "signup", to: 'user#new'
  post "users", to: 'user#create'
end
