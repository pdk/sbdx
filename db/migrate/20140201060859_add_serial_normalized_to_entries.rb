class AddSerialNormalizedToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :serial_normalized, :string
  end
end
