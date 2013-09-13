class ApiController < ApplicationController

  #GET /api/restaurants
  def index
    @restaurants = Restaurant.all
    render json: @restaurants
  end

  #GET /api/restaurants/{id}
  def show
    @restaurant = Restaurant.find(params[:id])
    render json: @restaurant
  end

end
