class AddTypeToConceptPostResource < ActiveRecord::Migration
  def change
    add_column :concept_post_resources, :type_res, :string
  end
end
