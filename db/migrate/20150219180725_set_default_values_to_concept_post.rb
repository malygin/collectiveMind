class SetDefaultValuesToConceptPost < ActiveRecord::Migration
  def up
    change_column :concept_posts, :number_views, :integer, default: 0
    change_column :concept_posts, :status, :integer, default: 0
  end

  def down
    change_column :concept_posts, :number_views, :integer
    change_column :concept_posts, :status, :integer
  end
end
