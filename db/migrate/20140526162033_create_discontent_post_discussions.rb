class CreateDiscontentPostDiscussions < ActiveRecord::Migration
  def change
    create_table :discontent_post_discussions do |t|
      t.integer :user_id
      t.integer :aspect_id
      t.integer :post_id

      t.timestamps
    end
  end
end
