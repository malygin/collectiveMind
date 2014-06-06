class CreatePlanPostActions < ActiveRecord::Migration
  def change
    create_table :plan_post_actions do |t|
      t.integer :plan_post_aspect_id
      t.string :name
      t.text :desc
      t.date :date_begin
      t.date :date_end
      t.integer :status

      t.timestamps
    end
  end
end
