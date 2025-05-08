Rails.application.routes.draw do
  resources :users
  resources :books, only: %i[index new create show edit update destroy] do
    resources :comments, only: %i[create edit destroy], shallow: true
    collection do
      get :bookmarks
      get :reads
    end
  end
  resources :bookmarks, only: %i[create destroy index]
  resources :hasreads, only: %i[create destroy]
  resource :login, only: %i[ new create ]
  resource :logout, only: %i[ show ]
  get 'tagsearches/search', to: 'tagsearches#search'
  root 'books#ranking'
  get :sign_up, to: 'users#new'
  post :sign_up, to: 'users#create'
  get 'search', to: 'books#search', as: 'search_books'
end