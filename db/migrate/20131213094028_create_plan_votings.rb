class CreatePlanVotings < ActiveRecord::Migration
  def change
    create_table :plan_votings do |t|
      t.integer :user_id
      t.integer :plan_post_id

      t.timestamps
    end
  end
end
