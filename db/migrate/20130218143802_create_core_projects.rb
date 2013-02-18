class CreateCoreProjects < ActiveRecord::Migration
  def change
    create_table :core_projects do |t|
      t.string :name, :limit => 500
      t.text :desc
      t.text :short_desc
      t.integer :status

      t.timestamps
    end
    add_index :core_projects, :status
  end
end
