class CreateDeviceTokens < ActiveRecord::Migration
  def change
    create_table :device_tokens do |t|
      t.text :token
      t.string :type

      t.timestamps
    end
  end
end
