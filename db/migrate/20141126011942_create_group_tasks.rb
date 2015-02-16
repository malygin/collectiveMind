class CreateGroupTasks < ActiveRecord::Migration
  def change
    create_table :group_tasks do |t|
      t.string :name
      t.text :description
      t.references :group, index: true

      t.timestamps
    end
  end
end
