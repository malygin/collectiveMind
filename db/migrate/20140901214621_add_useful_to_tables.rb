class AddUsefulToTables < ActiveRecord::Migration
  def change
    add_column :life_tape_comments, :useful, :boolean
    add_column :discontent_comments, :useful, :boolean
    add_column :plan_comments, :useful, :boolean
    add_column :estimate_comments, :useful, :boolean
    add_column :essay_comments, :useful, :boolean

    add_column :life_tape_posts, :useful, :boolean
    add_column :discontent_posts, :useful, :boolean
    add_column :concept_posts, :useful, :boolean
    add_column :plan_posts, :useful, :boolean
    add_column :estimate_posts, :useful, :boolean
    add_column :essay_posts, :useful, :boolean
  end
end
