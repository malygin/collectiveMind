class CreateEstimatePostAspects < ActiveRecord::Migration
  def change
    create_table :estimate_post_aspects do |t|
      t.integer :post_id
      t.integer :plan_post_aspect_id
      t.integer :op1
      t.integer :op2
      t.integer :op3
      t.text :op
      t.integer :ozf1
      t.integer :ozf2
      t.integer :ozf3
      t.text :ozf
      t.integer :ozs1
      t.integer :ozs2
      t.integer :ozs3
      t.text :ozs
      t.integer :on1
      t.integer :on2
      t.integer :on3
      t.text :on
      t.timestamps
    end
  end
end