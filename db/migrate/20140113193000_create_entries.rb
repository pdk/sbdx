class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :sbdx_member
      t.string :sbdx_member_entry_identifier
      t.date :date_missing
      t.date :date_recovered
      t.date :date_abandoned
      t.string :neighborhood
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.string :brand
      t.integer :year
      t.string :model
      t.string :color
      t.string :size
      t.string :serial_number
      t.string :owner_name
      t.text :circumstances
      t.text :bicycle_description
      t.boolean :reward
      t.string :info_url
      t.string :sighting_report_url
      t.text :sighting_report_instructions
      t.string :photo_1_url
      t.string :photo_2_url
      t.string :photo_3_url

      t.timestamps
    end
  end
end
