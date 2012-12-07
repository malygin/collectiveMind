class CreateConceptTaskSupplyPairs < ActiveRecord::Migration
  def change
    create_table :concept_task_supply_pairs do |t|
      t.text :task
      t.text :supply
      t.integer :post_id
      t.integer :order

      t.timestamps
    end
    add_index :concept_task_supply_pairs, :post_id
  end
end
