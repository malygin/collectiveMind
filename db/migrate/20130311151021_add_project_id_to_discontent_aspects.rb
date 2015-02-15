class AddProjectIdToDiscontentAspects < ActiveRecord::Migration
  def change
    add_column :core_aspects, :project_id, :integer
    add_index :core_aspects, :project_id

  end
end
