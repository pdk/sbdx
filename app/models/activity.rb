class Activity < ActiveRecord::Base
  attr_accessible :activity, :message, :sbdx_member, :sbdx_member_entry_identifier, :status


  def Activity.record(sbdx_member, sbdx_member_entry_identifier, activity, status=nil, message=nil)
    Activity.create!(
      :sbdx_member                   => sbdx_member,
      :sbdx_member_entry_identifier  => sbdx_member_entry_identifier,
      :activity                      => activity,
      :status                        => status,
      :message                       => message
    )
  end
end
