Rails.application.routes.draw do
  root to: 'widgets#index'
  devise_for :users, path_prefix: 'my'
  resources :users
  resources :rules
  resources :widgets
  resources :knx_modules
  resources :administrates
  resources :rooms
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
