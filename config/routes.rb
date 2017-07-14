Rails.application.routes.draw do
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'

  post '/login', to: 'sessions#create'

  delete '/logout', to: 'sessions#destroy'

  resources :users
  resources :password_resets, only: [ :new, :create, :edit, :update ]
  resources :account_activations, only: [ :edit ]

  root 'static_pages#home'
end
