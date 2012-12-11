class CreateConceptComments < ActiveRecord::Migration
  def change
    create_table :concept_comments do |t|
      t.text :content
      t.integer :user_id
      t.integer :post_id
      t.boolean :useful

      t.timestamps
    end
    add_index :concept_comments, :user_id
    add_index :concept_comments, :post_id
    add_index :concept_comments, :created_at
  end
end
