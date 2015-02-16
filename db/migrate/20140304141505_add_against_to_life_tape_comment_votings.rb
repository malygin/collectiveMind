class AddAgainstToLifeTapeCommentVotings < ActiveRecord::Migration
  def change
    add_column :life_tape_comment_votings, :against, :boolean, :default => true
    add_column :discontent_comment_votings, :against, :boolean, :default => true
  end
end
