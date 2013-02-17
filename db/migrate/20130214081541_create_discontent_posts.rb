class CreateDiscontentPosts < ActiveRecord::Migration
  def change
    create_table :discontent_posts do |t|
      t.text :content
      t.text :when
      t.text :where
      t.integer :user_id
      t.integer :status

      t.timestamps
    end
  end
end
