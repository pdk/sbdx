class AddEntryIdentifierIndex < ActiveRecord::Migration
  def up
    add_index :entries, [:sbdx_member, :sbdx_member_entry_identifier], :unique => true, :name => :entry_ak
  end

  def down
    remove_index :entries, :name => :entry_ak
  end
end
