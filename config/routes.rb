Ttr::Application.routes.draw do

  devise_for :admins
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  resources :restaurant, :controller => "place", :type => "Restaurant" do
    get 'near', on: :collection
  end
  resources :bar, :controller => "place", :type => "Bar" do
    get 'near', on: :collection
  end
  resources :place, :controller => "place", :type => "Place" do
    get 'near', on: :collection
  end

  root :to => redirect('/admin')
end
