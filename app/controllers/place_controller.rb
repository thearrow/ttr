class PlaceController < ApplicationController
  include Geokit::Geocoders

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

  # GET /{place_type}/near?lat=XX.XXX&lng=XX.XXX&rad=XX
  # OR GET /{place_type}/near?text={Search Text}&rad=XX
  #
  # lat = latitude of origin to search from
  # lng = longitude of origin to search from
  # rad = radius to search in (miles)
  # text = address/zip/city/etc to search from
  # (distance calculated from lat&long using Haversine Formula)
  def near
    if params[:lat] and params[:lng]
      lat, lng = params[:lat], params[:lng]
    else
      coords = MultiGeocoder.geocode(params[:text])
      lat, lng = coords.lat, coords.lng
    end
    @places = place_type.by_distance(within: params[:rad], origin: [lat, lng])
    render json: @places
  end

private
  def place_type
    params[:type].constantize
  end

end
