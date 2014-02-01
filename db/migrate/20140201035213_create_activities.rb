class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :sbdx_member
      t.string :sbdx_member_entry_identifier
      t.string :activity
      t.string :status
      t.string :message

      t.timestamps
    end
  end
end
