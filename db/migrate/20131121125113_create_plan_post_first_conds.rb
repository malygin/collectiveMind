class CreatePlanPostFirstConds < ActiveRecord::Migration
  def change
    create_table :plan_post_first_conds do |t|
      t.integer :plan_post_id
      t.integer :post_aspect_id

      t.text :positive
      t.text :negative
      t.text :control

      t.text :problems
      t.text :problems_with_resources
      t.text :reality

      t.string :name
      t.string  :content
      t.timestamps
    end
  end
end
