class RenameLifeTapeCommentVoiting < ActiveRecord::Migration
  def up
  	rename_table :life_comment_votings, :life_tape_comment_votings

  end

  def down
  	rename_table :life_tape_comment_votings, :life_comment_votings

  end
end
