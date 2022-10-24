Rails.application.routes.draw do
  devise_for :users
  resources :users
  resources :posts, :comments, except: :new do
    resources :comments, except: :new
    resources :likes, only: %i[create destroy]
  end

  resource :dashboard, only: :show

  root 'dashboard#show'
end
