class CreatePlanTaskTriplets < ActiveRecord::Migration
  def change
    create_table :plan_task_triplets do |t|
      t.integer :post_id
      t.integer :position
      t.boolean :compulsory
      t.text :task
      t.text :supply
      t.text :howto

      t.timestamps
    end
    add_index :plan_task_triplets, :post_id

  end
end
