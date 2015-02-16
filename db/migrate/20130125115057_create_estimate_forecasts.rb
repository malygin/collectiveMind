class CreateEstimateForecasts < ActiveRecord::Migration
  def change
    create_table :estimate_forecasts do |t|
      t.integer :user_id
      t.integer :best_student_post_id
      t.integer :best_jury_post_id

      t.timestamps
    end
    add_index :estimate_forecasts,:user_id

  end
end
