Rails.application.routes.draw do
  resources :users
  resources :books
  resource :login, only: %i[ new create ]
  resource :logout, only: %i[ show ]
end