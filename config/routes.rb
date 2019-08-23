Rails.application.routes.draw do
  get 'admin/load'
  post 'admin/load'
  get 'retro/showall'
  get 'retro/:date', to: 'retro#day'
  root 'retro#showall'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
