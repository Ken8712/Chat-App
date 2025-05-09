
Rails.application.routes.draw do
  root to: "messages#index"
  devise_for :users
  resources :users, only: [:edit, :update, :destroy]
  resources :rooms, only: [:new, :create]
end