Rails.application.routes.draw do
  devise_for :users
  resources :users
  resources :posts, :comments do
    resources :comments
    resources :likes, only: %i[create destroy]
  end

  resource :dashboard, only: :show

  root 'dashboard#show'
end
