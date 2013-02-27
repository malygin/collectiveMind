class AddProjectToLifeTapePost < ActiveRecord::Migration
  def change
    add_column :life_tape_posts, :project_id, :integer
    add_index :life_tape_posts, :project_id

  end
end
