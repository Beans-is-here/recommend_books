Rails.application.routes.draw do
  resources :users
  root 'top#index'
  resources :login, only: %i[ new create ]
  resources :logout, only: %i[ show ]
end
