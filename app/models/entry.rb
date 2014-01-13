class Entry < ActiveRecord::Base
  attr_accessible :bicycle_description, :brand, :circumstances, :city, :color, :country, :date_abandoned, :date_missing, :date_recovered,
    :info_url, :model, :neighborhood, :owner_name, :photo_1_url, :photo_2_url, :photo_3_url, :reward, :sbdx_member, :sbdx_member_entry_identifier,
    :serial_number, :sighting_report_instructions, :sighting_report_url, :size, :state, :year, :zip
end
