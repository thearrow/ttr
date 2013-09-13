Ttr::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :restaurant

  root :to => redirect('/admin')
end
