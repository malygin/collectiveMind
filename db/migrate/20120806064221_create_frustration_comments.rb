class CreateFrustrationComments < ActiveRecord::Migration
  def change
    create_table :frustration_comments do |t|
      t.string :content
      t.integer :user_id
      t.integer :frustration_id

      t.timestamps
    end
    add_index :frustration_comments, :user_id
    add_index :frustration_comments, :frustration_id
    add_index :frustration_comments, :created_at
  end
end
