class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :name
      t.text :description
      t.string :url
      t.string :street
      t.string :city
      t.string :state
      t.string :zip
      t.string :neighborhood
      t.string :phone
      t.decimal :latitude, :precision => 15, :scale => 10
      t.decimal :longitude, :precision => 15, :scale => 10
      t.string :type
      t.boolean :food

      t.timestamps
    end
  end
end
