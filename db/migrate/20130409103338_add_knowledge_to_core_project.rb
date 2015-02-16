class AddKnowledgeToCoreProject < ActiveRecord::Migration
  def change
    add_column :core_projects, :knowledge, :text
  end
end
