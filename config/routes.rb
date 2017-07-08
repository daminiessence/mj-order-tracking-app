Rails.application.routes.draw do
  resources :users

  get '/signup', to: 'users#new'

  root 'static_pages#home'
end
