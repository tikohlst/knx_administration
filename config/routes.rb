Rails.application.routes.draw do
  scope "/:locale" do
    root to: 'widgets#index'
    devise_for :users, path_prefix: '/:locale/my', controllers: { registrations: 'registrations' }
    resources :users
    resources :widgets
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
