class CreateTests < ActiveRecord::Migration
  def change
    create_table :tests do |t|
      t.string :name
      t.string :description
      t.integer :project_id
      t.datetime :begin_date
      t.datetime :end_date
      t.timestamps
    end
    add_index :tests, :begin_date 
    add_index :tests, :end_date 
  end
end
