class CreatePlanComments < ActiveRecord::Migration
  def change
    create_table :plan_comments do |t|
      t.integer :user_id
      t.integer :post_id
      t.text :content

      t.timestamps
    end
    add_index :plan_comments, :post_id
  end
end
