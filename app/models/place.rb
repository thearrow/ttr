class Place < ActiveRecord::Base
  has_and_belongs_to_many :tag_atmospheres
  has_and_belongs_to_many :tag_best_fors
end
