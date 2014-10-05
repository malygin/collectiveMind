class AddApproveStatusToCommentsAndPosts < ActiveRecord::Migration
  def change
    add_column :life_tape_comments, :approve_status, :boolean
    add_column :discontent_comments, :approve_status, :boolean
    add_column :concept_comments, :approve_status, :boolean
    add_column :plan_comments, :approve_status, :boolean
    add_column :estimate_comments, :approve_status, :boolean
    add_column :essay_comments, :approve_status, :boolean

    add_column :discontent_posts, :approve_status, :boolean
    add_column :concept_posts, :approve_status, :boolean
    add_column :plan_posts, :approve_status, :boolean
    add_column :estimate_posts, :approve_status, :boolean
    add_column :essay_posts, :approve_status, :boolean
  end
end
