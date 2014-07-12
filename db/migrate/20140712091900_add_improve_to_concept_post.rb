class AddImproveToConceptPost < ActiveRecord::Migration
  def change
    add_column :concept_posts, :imp_comment, :integer
    add_column :concept_posts, :imp_stage, :integer
  end
end
