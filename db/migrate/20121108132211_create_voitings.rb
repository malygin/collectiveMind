class CreateVoitings < ActiveRecord::Migration
  def change
    create_table :voitings do |t|
      t.integer :user_id
      t.integer :frustration_id
      t.integer :score

      t.timestamps
    end
  end
end
