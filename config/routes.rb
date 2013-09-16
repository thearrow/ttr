Ttr::Application.routes.draw do

  devise_for :admins
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  resources :restaurant

  root :to => redirect('/admin')
end
