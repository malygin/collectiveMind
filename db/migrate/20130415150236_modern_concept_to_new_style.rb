class ModernConceptToNewStyle < ActiveRecord::Migration
  def change
	rename_table :concept_comment_voitings, :concept_comment_votings
	rename_table :concept_post_voitings, :concept_post_votings
	
	add_column :concept_posts, :project_id, :integer
    add_index :concept_posts, :project_id	

    add_column :concept_posts, :content, :text

  end
end
