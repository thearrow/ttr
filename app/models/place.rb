class Place < ActiveRecord::Base
  has_and_belongs_to_many :tag_atmospheres
  has_and_belongs_to_many :tag_best_fors

  acts_as_mappable :default_units => :miles,
                   :default_formula => :sphere,
                   :distance_field_name => :distance,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude
end
