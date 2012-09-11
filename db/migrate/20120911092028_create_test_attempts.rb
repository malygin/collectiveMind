class CreateTestAttempts < ActiveRecord::Migration
  def change
    create_table :test_attempts do |t|
      t.integer :test_id
      t.integer :user_id
      t.timestamps
    end
    add_index :test_attempts, :test_id
    add_index :test_attempts, :user_id
  end
end
