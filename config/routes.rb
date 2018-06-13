Rails.application.routes.draw do
  get 'users/index'
  get 'users/:id' => 'users#show'
  devise_for :users, :path_prefix => 'd'
  resources :users, :only =>[:show]

  # Route für Widget Controller-Methode rules
  get 'widgets/:id/rules' => 'widgets#rules'
  get 'widgets/rules' => 'widgets#rules'

  root to: 'widgets#show'
  resources :rules
  resources :widgets
  resources :knx_modules
  resources :administrates
  resources :rooms
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
