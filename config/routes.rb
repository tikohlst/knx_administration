Rails.application.routes.draw do
  root to: 'widgets#index'
  devise_for :users, path_prefix: 'my'
  resources :users
  resources :widgets do
    get 'sort_by_org_units', on: :collection
    get 'sort_by_locations', on: :collection
    get 'sort_alphabetically', on: :collection
    get 'sort_backwards_alphabetically', on: :collection
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
