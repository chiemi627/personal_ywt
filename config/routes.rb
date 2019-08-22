Rails.application.routes.draw do
  get 'admin/load'
  post 'admin/load'
  get 'retro/showall'
  root 'retro#showall'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
