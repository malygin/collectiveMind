class CreateLogger < ActiveRecord::Migration
  def change
    create_table :journal_loggers do |t|
      t.integer :user_id
      t.string :type_event
      t.text :body
      t.integer :project_id
      t.integer :first_id
      t.integer :second_id
      t.string :body2
      t.integer :user_informed
      t.boolean :viewed
      t.boolean :personal, default: false
      t.boolean :visible, default: true

      t.timestamps null: false
    end
  end
end
