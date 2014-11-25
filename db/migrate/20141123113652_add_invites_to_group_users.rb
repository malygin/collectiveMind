class AddInvitesToGroupUsers < ActiveRecord::Migration
  def change
    add_column :group_users, :invite_accepted, :boolean
    GroupUser.update_all invite_accepted: true
  end
end
