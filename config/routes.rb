Rails.application.routes.draw do
  get 'sessions/new'
  get 'users/new'
  post 'users/create'
  get 'users/index'
  get 'admin/load'
  post 'admin/load'
  get 'admin/login'
  get 'admin/logout'
  post 'admin/logged_in'
  get 'retro/showall'
  get 'd/:date', to: 'retro#day'
  get 'm/:member_id', to: 'retro#member'
  get 't/:team_id', to: 'retro#team'
  root 'retro#index'
  get '/login', to:'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :account_activations, only: [:edit]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
