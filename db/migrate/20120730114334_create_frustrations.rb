class CreateFrustrations < ActiveRecord::Migration
  def change
    create_table :frustrations do |t|
      t.string :what
      t.string :wherin
      t.string :when
      t.string :what_old
      t.string :wherin_old
      t.string :when_old
      t.integer :user_id
      t.integer :status, :default => 0
      t.timestamps
    end
    add_index :frustrations, :user_id
    add_index :frustrations, :status
    add_index :frustrations, :created_at
  end
end
