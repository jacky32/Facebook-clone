Rails.application.routes.draw do
  devise_for :users
  resources :posts, :comments do
    resources :comments
    resources :likes, only: %i[create destroy]
  end

  root 'posts#index'
end
