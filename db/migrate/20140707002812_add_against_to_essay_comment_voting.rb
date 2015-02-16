class AddAgainstToEssayCommentVoting < ActiveRecord::Migration
  def change
    add_column :essay_comment_votings, :against, :boolean
  end
end
