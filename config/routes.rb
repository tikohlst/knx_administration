Rails.application.routes.draw do
  get 'users/index'
  get 'users/:id' => 'users#show'
  devise_for :users, :path_prefix => 'd'
  resources :users, :only =>[:show]

  root to: 'widgets#show'
  resources :rules
  resources :widgets
  resources :knx_modules
  resources :administrates
  resources :rooms
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
