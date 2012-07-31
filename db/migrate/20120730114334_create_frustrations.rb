class CreateFrustrations < ActiveRecord::Migration
  def change
    create_table :frustrations do |t|
      t.string :content
      t.integer :user_id
      t.boolean :structure, :default => false

      t.timestamps
    end
    add_index :frustrations, :user_id
    add_index :frustrations, :created_at
  end
end
