class PlaceController < ApplicationController

  #GET /{place_type}
  # eg. /places OR /restaurants OR /bars
  def index
    @places = place_type.all
    render json: @places
  end

  #GET /{place_type}/{id}
  def show
    @place = place_type.find(params[:id])
    render json: @place
  end

  #GET /{place_type}/near?lat=XX.XXX&lng=XX.XXX&rad=XX
  # lat = latitude of origin to search from
  # lng = longitude of origin to search from
  # rad = radius to search in (miles)
  # distance calculated from lat&long using Haversine Formula
  def near
    @places = place_type.within(params[:rad], :origin => [params[:lat], params[:lng]])
    render json: @places
  end

private
  def place_type
    params[:type].constantize
  end

end
