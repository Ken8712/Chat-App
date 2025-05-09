
Rails.application.routes.draw do
  root to: "rooms#index"
  devise_for :users
  resources :users, only: [:edit, :update, :destroy]
  resources :rooms, only: [:index, :new, :create]
end