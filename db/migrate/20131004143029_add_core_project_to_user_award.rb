class AddCoreProjectToUserAward < ActiveRecord::Migration
  def change
    add_column :user_awards, :project_id, :integer
  end
end
