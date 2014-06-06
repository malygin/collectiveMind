class CreatePlanPostStages < ActiveRecord::Migration
  def change
    create_table :plan_post_stages do |t|
      t.integer :post_id
      t.string :name
      t.text :desc
      t.date :date_begin
      t.date :date_end
      t.integer :status

      t.timestamps
    end
  end
end
