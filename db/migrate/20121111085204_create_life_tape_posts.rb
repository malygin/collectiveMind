class CreateLifeTapePosts < ActiveRecord::Migration
  def change
    create_table :life_tape_posts do |t|
      t.text :content
      t.integer :user_id
      t.integer :post_id
      t.integer :category_id

      t.timestamps
    end
  end
end
