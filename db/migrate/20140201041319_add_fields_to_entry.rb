class AddFieldsToEntry < ActiveRecord::Migration
  def change
    add_column :entries, :police_report_filed_with, :string
    add_column :entries, :police_report_reference, :string
    add_column :entries, :stolen_from, :text
  end
end
