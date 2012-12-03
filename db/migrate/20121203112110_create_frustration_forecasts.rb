class CreateFrustrationForecasts < ActiveRecord::Migration
  def change
    create_table :frustration_forecasts do |t|
      t.integer :user_id
      t.integer :frustration_id
      t.integer :order

      t.timestamps
    end
    add_index :frustration_forecasts, :user_id
    add_index :frustration_forecasts, :frustration_id

  end
end
