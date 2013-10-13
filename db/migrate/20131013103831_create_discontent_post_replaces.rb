class CreateDiscontentPostReplaces < ActiveRecord::Migration
  def change
    create_table :discontent_post_replaces do |t|
      t.integer :post_id
      t.integer :replace_id

      t.timestamps
    end
    add_index :discontent_post_replaces, :post_id
    add_index :discontent_post_replaces, :replace_id

  end
end
