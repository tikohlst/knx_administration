Rails.application.routes.draw do
  scope "/:locale" do
    root to: 'widgets#index'
    devise_for :users, path_prefix: '/:locale/my', controllers: { registrations: 'registrations' }
    resources :users do
      get 'sort_by_ids', on: :collection
      get 'sort_by_roles', on: :collection
      get 'sort_by_usernames', on: :collection
    end
    resources :widgets do
      get 'sort_by_org_units', on: :collection
      get 'sort_by_locations', on: :collection
      get 'sort_alphabetically', on: :collection
      get 'sort_backwards_alphabetically', on: :collection
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
