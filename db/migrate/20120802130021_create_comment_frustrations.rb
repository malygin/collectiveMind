class CreateCommentFrustrations < ActiveRecord::Migration
  def change
    create_table :comment_frustrations do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
  end
end
