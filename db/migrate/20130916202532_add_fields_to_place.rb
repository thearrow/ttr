class AddFieldsToPlace < ActiveRecord::Migration
  def change
    add_column :places, :reservations, :boolean
    add_column :places, :reservations_link, :string
    add_column :places, :tt_article, :string
    add_column :places, :tt_date, :datetime
    add_column :places, :price, :integer
    add_column :places, :outdoor, :boolean
  end
end
