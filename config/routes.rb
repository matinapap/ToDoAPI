Rails.application.routes.draw do
  resources :todos do
    resources :items, only: [:index, :create, :show, :update, :destroy]
  end
  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'
end
