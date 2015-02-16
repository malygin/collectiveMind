class CreateJournals < ActiveRecord::Migration
  def change
    create_table :journals do |t|
      t.integer :user_id
      t.string :type
      t.string :body

      t.timestamps
    end
    add_index :journals, :user_id
    add_index :journals, :type
    add_index :journals, :created_at
  end
end
