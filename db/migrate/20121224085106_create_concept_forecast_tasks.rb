class CreateConceptForecastTasks < ActiveRecord::Migration
  def change
    create_table :concept_forecast_tasks do |t|
      t.integer :user_id
      t.text :content
      t.text :description

      t.timestamps
    end
  end
end
