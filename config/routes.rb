
Rails.application.routes.draw do
  root to: "rooms#index"
  devise_for :users
  resources :users, only: [:edit, :update, :destroy]
  resources :rooms, only: [:index, :new, :create, :destroy] do
        resources :messages, only: [:index, :create]
  end
  resources :messages, only: [:index, :create]
end