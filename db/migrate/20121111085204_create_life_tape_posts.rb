class CreateLifeTapePosts < ActiveRecord::Migration
  def change
    create_table :life_tape_posts do |t|
      t.text :content
      t.integer :user_id
      t.integer :post_id
      t.integer :category_id
      t.timestamps
    end
    add_index :life_tape_posts, :user_id
    add_index :life_tape_posts, :category_id
    add_index :life_tape_posts, :post_id
    add_index :life_tape_posts, :created_at
  end
end
