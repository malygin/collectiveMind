class CreatePlanPostResources < ActiveRecord::Migration
  def change
    create_table :plan_post_resources do |t|
      t.string :name
      t.text :desc
      t.integer :post_id
      t.integer :resource_id

      t.timestamps
    end
  end
end
