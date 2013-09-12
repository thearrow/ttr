class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :description
      t.string :url
      t.string :street
      t.string :city
      t.string :state
      t.string :zip
      t.string :neighborhood
      t.string :phone
      t.decimal :latitude, :precision => 15, :scale => 10
      t.decimal :longitude, :precision => 15, :scale => 10

      t.timestamps
    end
  end
end
