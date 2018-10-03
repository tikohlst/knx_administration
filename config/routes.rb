Rails.application.routes.draw do
  scope "/:locale" do
    root to: 'widgets#index'
    devise_for :user, skip: [:sessions], controllers: { registrations: 'registrations' }
    as :user do
      get 'login', to: 'devise/sessions#new', as: :new_user_session
      post 'login', to: 'devise/sessions#create', as: :user_session
      delete 'logout', to: 'devise/sessions#destroy', as: :destroy_user_session
    end
    resources :users
    resources :widgets
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
