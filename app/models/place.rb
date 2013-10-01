class Place < ActiveRecord::Base
  include Geokit::Geocoders
  has_and_belongs_to_many :tag_atmospheres
  has_and_belongs_to_many :tag_best_fors

  acts_as_mappable :default_units => :miles,
                   :default_formula => :sphere,
                   :distance_field_name => :distance,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude

  before_update :address_to_coords
  after_commit :clear_entire_cache

  def address_to_coords
    if self.latitude.nil? or self.longitude.nil?
      coords = MultiGeocoder.geocode("#{self.street} #{self.city}, #{self.state} #{self.zip}")
      self.latitude = coords.lat
      self.longitude = coords.lng
    end
  end

  def clear_entire_cache
    Rails.cache.clear
  end
end
