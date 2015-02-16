class AddStyleToConceptResource < ActiveRecord::Migration
  def change
    add_column :concept_post_resources, :concept_post_resource_id, :integer
    add_column :concept_post_resources, :style, :integer
  end
end
