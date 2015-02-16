class FixColumnNameTypeForCommentNotes < ActiveRecord::Migration
  def change
    rename_column :discontent_comment_notes, :type, :type_field
  end
end
