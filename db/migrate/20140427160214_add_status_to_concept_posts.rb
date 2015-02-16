class AddStatusToConceptPosts < ActiveRecord::Migration
  def change
    add_column :concept_posts, :stat_name, :boolean
    add_column :concept_posts, :stat_content, :boolean
    add_column :concept_posts, :stat_positive, :boolean
    add_column :concept_posts, :stat_positive_r, :boolean
    add_column :concept_posts, :stat_negative, :boolean
    add_column :concept_posts, :stat_negative_r, :boolean
    add_column :concept_posts, :stat_problems, :boolean
    add_column :concept_posts, :stat_reality, :boolean
  end
end
