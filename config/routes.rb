Rails.application.routes.draw do
  root to: 'widgets#index'
  devise_for :users, path_prefix: 'my'
  resources :users
  resources :widgets
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
