class CreateDiscontentCommentNotes < ActiveRecord::Migration
  def change
    create_table :discontent_comment_notes do |t|
      t.text :content
      t.integer :user_id
      t.integer :post_id
      t.integer :type

      t.timestamps
    end
  end
end
