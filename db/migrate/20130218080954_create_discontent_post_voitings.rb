class CreateDiscontentPostVoitings < ActiveRecord::Migration
  def change
    create_table :discontent_post_voitings do |t|
      t.integer :user_id
      t.integer :post_id

      t.timestamps
    end
         add_index :discontent_post_voitings, :user_id
    add_index :discontent_post_voitings, :post_id
    add_index :discontent_post_voitings, [:post_id, :user_id]
  end
end
