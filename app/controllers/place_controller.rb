class PlaceController < ApplicationController
  include Geokit::Geocoders

  # GET /{place_type}
  # eg. /places OR /restaurants OR /bars
  def index
    @places = place_type.all.includes([:tag_atmospheres, :tag_best_fors])
    render json: @places.to_json(include: [:tag_atmospheres, :tag_best_fors])
  end

  # GET /{place_type}/{id}
  def show
    @place = place_type.find(params[:id])
    render json: @place
  end

  # GET /{place_type}/near?lat={lat}&lng={lng}&rad={rad}
  # OR GET /{place_type}/near?text={text}&rad={rad}
  #
  # eg. /restaurants/near?lat=40.124&lng=80.123&rad=10
  # eg. /bars/near?text=43202&rad=10
  #
  # lat = latitude of origin to search from
  # lng = longitude of origin to search from
  # text = address/zip/city/etc to search from
  # rad = radius to search in (miles)
  def near
    if params[:lat] and params[:lng]
      lat, lng = params[:lat], params[:lng]
    else
      coords = MultiGeocoder.geocode(params[:text])
      lat, lng = coords.lat, coords.lng
    end
    # save json result in memcache to prevent repeated db hits, use url as key
    results = Rails.cache.fetch "/#{place_type}/near?lat=#{lat}&lng=#{lng}&rad=#{params[:rad]}" do
      # eager-load the tags, resulting in ~3 db hits instead of n+1
      places = place_type.within(params[:rad], origin: [lat, lng]).includes([:tag_atmospheres, :tag_best_fors])
      places.sort! {|a,b| a.distance_to([lat,lng]) <=> b.distance_to([lat,lng])}
      places.to_json(include: [:tag_atmospheres, :tag_best_fors])
    end
    render json: results
  end

  # GET /{place_type}/search?text={Search String}
  # OR GET /{place_type}/search?text={Search String}&lat={lat}&lng={lng}
  #
  # eg. /places/search?text=cafe
  # eg. /bars/search?text=dive&lat=40.123&lng=80.123
  #
  # text = search text
  # lat = (optional) latitude of origin to search from
  # lng = (optional) longitude of origin to search from
  #
  # this simple SQL-powered search must do a full table scan for each query
  # if performance becomes an issue, look into running a dedicated search server
  # like ElasticSearch (tire gem), Solr (sunspot_rails gem), or Sphinx (thinking-sphinx gem)
  # (these also bring additional benefits like fuzzy-matching and accent-mark ignoring)
  def search
    if params[:lat] and params[:lng]
      lat, lng = params[:lat], params[:lng]
      # TODO: implement nearby search
    end
    query = params[:text]
    # save json result in memcache to prevent repeated db hits, use url as key
    results = Rails.cache.fetch "/#{place_type}/search?text=#{query}" do
      # squeel DSL for 'like' wildcard query, match name or description, eagar-load tags
      place_type.where{(name =~ "%#{query}%") | (description =~ "%#{query}%")}
        .includes([:tag_atmospheres, :tag_best_fors])
        .to_json(include: [:tag_atmospheres, :tag_best_fors])
    end
    render json: results
  end

private
  def place_type
    params[:type].constantize
  end
end
