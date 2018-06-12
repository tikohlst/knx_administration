Rails.application.routes.draw do
  devise_for :users
  root to: 'widgets#show'
  resources :rules
  resources :widgets
  resources :knx_modules
  resources :administrates
  resources :rooms
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
