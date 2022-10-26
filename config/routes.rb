Rails.application.routes.draw do
  devise_for :users
  resources :users
  resources :posts, :comments, except: :new do
    resources :comments, except: :new
    resources :likes, only: %i[create destroy]
  end

  get '*path', to: redirect('/')

  resource :dashboard, only: :show

  resources :friendships, only: %i[create update destroy]

  root 'dashboard#show'
end
