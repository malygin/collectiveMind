class CreateUserChecks < ActiveRecord::Migration
  def change
    create_table :user_checks do |t|
      t.integer :user_id
      t.string :check_field
      t.boolean :status
      t.integer :project_id

      t.timestamps
    end
  end
end
