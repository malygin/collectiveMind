class CreateConceptForecasts < ActiveRecord::Migration
  def change
    create_table :concept_forecasts do |t|
      t.integer :forecast_task_id
      t.integer :position
      t.integer :user_id

      t.timestamps
    end
    add_index :concept_forecasts, :forecast_task_id
    add_index :concept_forecasts, :user_id
  end
end
