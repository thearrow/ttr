class CreateTags < ActiveRecord::Migration
  def change

    create_table :tag_atmospheres do |t|
      t.string :name
      t.timestamps
    end

    create_table :tag_best_fors do |t|
      t.string :name
      t.timestamps
    end

    create_table :places_tag_atmospheres do |t|
      t.belongs_to :place
      t.belongs_to :tag_atmosphere
    end

    create_table :places_tag_best_fors do |t|
      t.belongs_to :place
      t.belongs_to :tag_best_for
    end
  end
end
