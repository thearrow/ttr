class RestaurantController < ApplicationController

  #GET /restaurant
  def index
    @restaurants = Restaurant.all
    render json: @restaurants
  end

  #GET /restaurant/{id}
  def show
    @restaurant = Restaurant.find(params[:id])
    render json: @restaurant
  end

end
