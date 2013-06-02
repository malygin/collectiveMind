class CreateCoreProjectUsers < ActiveRecord::Migration
  def change
    create_table :core_project_users do |t|
      t.integer :project_id
      t.integer :user_id
      t.integer :status

      t.timestamps
    end
    add_index :core_project_users, :project_id
    add_index :core_project_users, :user_id
  end
end
