class AddProjectToConceptPostResource < ActiveRecord::Migration
  def change
    add_column :concept_post_resources, :project_id, :integer
  end
end
