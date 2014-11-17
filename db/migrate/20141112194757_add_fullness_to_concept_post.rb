class AddFullnessToConceptPost < ActiveRecord::Migration
  def change
    add_column :concept_posts, :fullness, :integer
  end
end
