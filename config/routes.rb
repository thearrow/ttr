Ttr::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  get 'api/restaurants' => 'api#index'
  get 'api/restaurants/:id' => 'api#show'

  root :to => redirect('/admin')
end
