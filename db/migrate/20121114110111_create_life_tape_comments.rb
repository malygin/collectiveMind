class CreateLifeTapeComments < ActiveRecord::Migration
  def change
    create_table :life_tape_comments do |t|
      t.text :content
      t.integer :user_id
      t.integer :post_id

      t.timestamps
    end
    add_index :life_tape_comments, :user_id
    add_index :life_tape_comments, :post_id
    add_index :life_tape_comments, :created_at
  end
end
