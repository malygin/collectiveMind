class AddProjectIdToDiscontentAspects < ActiveRecord::Migration
  def change
    add_column :discontent_aspects, :project_id, :integer
    add_index :discontent_aspects, :project_id

  end
end
