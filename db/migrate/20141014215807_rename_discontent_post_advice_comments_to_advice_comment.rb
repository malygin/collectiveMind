class RenameDiscontentPostAdviceCommentsToAdviceComment < ActiveRecord::Migration
  def change
    rename_table :discontent_post_advice_comments, :advice_comments
  end
end
