class CreatePlanPosts < ActiveRecord::Migration
  def change
    create_table :plan_posts do |t|
      t.integer :user_id
      t.text :goal
      t.text :first_step
      t.text :other_steps
      t.integer :status
      t.integer :number_views

      t.timestamps
    end
  end
end
