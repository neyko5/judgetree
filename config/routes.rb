Rails.application.routes.draw do
  devise_for :users
  resources :judges, only: [:new, :create, :index, :update,:edit,:destroy]
  resources :tree
  root to: 'tree#index'

end
