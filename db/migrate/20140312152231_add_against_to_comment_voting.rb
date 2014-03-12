class AddAgainstToCommentVoting < ActiveRecord::Migration
  def change
    add_column :plan_post_votings, :against, :boolean, :default => true
    #add_column :estimate_post_votings, :against, :boolean, :default => true
    add_column :concept_comment_votings, :against, :boolean, :default => true
    add_column :plan_comment_votings, :against, :boolean, :default => true
    add_column :estimate_comment_votings, :against, :boolean, :default => true

  end
end
