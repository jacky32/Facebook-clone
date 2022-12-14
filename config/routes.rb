Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth' }
  resources :users
  resources :user_infos, only: %i[update]

  resources :posts, :comments, only: %i[show create update destroy] do
    resources :comments, only: %i[show create update destroy]
    resources :likes, only: %i[create destroy]
  end

  resources :friendships, only: %i[show create update destroy]

  resources :memberships, only: %i[create update destroy]
  resources :communities, except: %i[new edit]

  resources :messages, only: %i[create]
  resources :chats, only: %i[create show]

  resources :notifications, only: %i[create show destroy]

  get '*path/show_recent_chat/:id', to: 'chats#show_recent_chat'
  get 'show_recent_chat/:id', to: 'chats#show_recent_chat'

  post 'set_profile', to: 'users#set_profile'
  post 'set_friends', to: 'users#set_friends'

  get 'get_profile', to: 'users#get_profile'
  get 'get_friends', to: 'users#get_friends'

  resource :dashboard, only: :show
  post 'modal', to: 'dashboard#modal'
  get 'search', to: 'dashboard#search'
  get 'search_results', to: 'dashboard#search_results'

  root 'dashboard#show'

  # get '*path', to: redirect('/')
end
