class AddInvitesToGroupUsers < ActiveRecord::Migration
  class GroupUser < ActiveRecord::Base
  end

  def change
    add_column :group_users, :invite_accepted, :boolean
    GroupUser.update_all invite_accepted: true
  end
end
