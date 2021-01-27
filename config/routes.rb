Rails.application.routes.draw do
  post '/events', to: 'events#create'
  get '/download', to: 'widgets#download'
  mount ActionCable.server => "/cable"
  get '/', to: redirect('/en/login')
  get '/de', to: redirect('/de/login')
  get '/en', to: redirect('/de/login')
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
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
