Rails.application.routes.draw do
  devise_for :users
  resources :users
  resources :posts, :comments, only: %i[create update destroy] do
    resources :comments, except: :new
    resources :likes, only: %i[create destroy]
  end

  # get '*path', to: redirect('/')

  post 'set_profile', to: 'users#set_profile'
  post 'set_friends', to: 'users#set_friends'

  get 'get_profile', to: 'users#get_profile'
  get 'get_friends', to: 'users#get_friends'

  resource :dashboard, only: :show
  post 'modal', to: 'dashboard#modal'
  get 'search', to: 'dashboard#search'

  resources :friendships, only: %i[create update destroy]

  root 'dashboard#show'
end
