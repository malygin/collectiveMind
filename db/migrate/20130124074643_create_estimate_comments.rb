class CreateEstimateComments < ActiveRecord::Migration
  def change
    create_table :estimate_comments do |t|
      t.integer :user_id
      t.integer :post_id
      t.text :content

      t.timestamps
    end
    add_index :estimate_comments, :post_id

  end
end
