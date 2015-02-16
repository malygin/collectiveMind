class AddCommentIdToConceptComment < ActiveRecord::Migration
  def change
    add_column :concept_comments, :comment_id, :integer
  end
end
