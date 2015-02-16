class CreateGroupTaskUsers < ActiveRecord::Migration
  def change
    create_table :group_task_users do |t|
      t.references :user, index: true
      t.references :group_task, index: true

      t.timestamps
    end
  end
end
