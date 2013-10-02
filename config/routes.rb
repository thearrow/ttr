Ttr::Application.routes.draw do

  devise_for :admins
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  resources :restaurants, :controller => "place", :type => "Restaurant" do
    get 'near', on: :collection
    get 'search', on: :collection
  end
  resources :bars, :controller => "place", :type => "Bar" do
    get 'near', on: :collection
    get 'search', on: :collection
  end
  resources :places, :controller => "place", :type => "Place" do
    get 'near', on: :collection
    get 'search', on: :collection
  end

  get '/push_notifications', :to => 'admin/push#index'

  root :to => redirect('/admin')
end
