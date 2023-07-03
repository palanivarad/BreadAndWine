Rails.application.routes.draw do
  root "landing#index"
  get "login", to: 'login#new'
  post "login", to: 'login#create'
  delete "logout", to: 'login#destroy'
  get 'password/forgot', to: 'login#forgot'
  post 'password/forgot', to: 'login#sendlink'
  get 'password/reset', to: 'login#reset'
  post 'password/reset', to: 'login#updatepassword', as: 'password_reset_edit'

  resources :user do
    member do
      get :confirm_email
    end
  end
  get "signup", to: 'user#new'
  post "users", to: 'user#create'

  resources :recipes
  get "myrecipes", to: 'recipes#myrecipes'

  resources :favorites, only: [:index, :create, :destroy]
end
