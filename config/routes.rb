Rails.application.routes.draw do
  root "landing#index"
  get "login", to: 'login#new'
  post "login", to: 'login#create'
  delete "logout", to: 'login#destroy'

  resources :user
  get "signup", to: 'user#new'
  post "users", to: 'user#create'

  resources :recipes
  get "myrecipes", to: 'recipes#myrecipes'

  resources :favorites, only: [:index, :create, :destroy]
end
