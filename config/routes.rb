Rails.application.routes.draw do
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'

  post '/login', to: 'sessions#create'

  delete '/logout', to: 'sessions#destroy'

  resources :users do
    resources :agent_verifications, only: [ :index, :update ]
  end
  resources :password_resets, only: [ :new, :create, :edit, :update ]
  resources :account_activations, only: [ :edit ]
  resources :orders
  resources :products

  root 'static_pages#home'
end
