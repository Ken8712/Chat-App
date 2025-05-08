
Rails.application.routes.draw do
  get 'messages/index'
  root to: "messages#index"
  devise_for :users
end