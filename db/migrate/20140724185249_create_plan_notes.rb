class CreatePlanNotes < ActiveRecord::Migration
  def change
    create_table :plan_notes do |t|
      t.text :content
      t.integer :post_id
      t.integer :user_id
      t.integer :type_field

      t.timestamps
    end
  end
end
