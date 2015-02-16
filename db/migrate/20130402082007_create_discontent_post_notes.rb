class CreateDiscontentPostNotes < ActiveRecord::Migration
  def change
    create_table :discontent_post_notes do |t|
      t.integer :post_id
      t.integer :user_id
      t.text :content

      t.timestamps
    end
     add_index :discontent_post_notes,:post_id

  end
end
