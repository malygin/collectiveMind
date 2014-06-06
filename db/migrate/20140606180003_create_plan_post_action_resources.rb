class CreatePlanPostActionResources < ActiveRecord::Migration
  def change
    create_table :plan_post_action_resources do |t|
      t.integer :post_action_id
      t.string :name
      t.text :desc
      t.integer :resource_id

      t.timestamps
    end
  end
end
