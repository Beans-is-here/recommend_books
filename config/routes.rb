Rails.application.routes.draw do
  get "password_resets/create"
  get "password_resets/edit"
  get "password_resets/update"
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
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
  resources :password_resets, only: [:new, :create, :edit, :update]
end