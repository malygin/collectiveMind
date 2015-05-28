class CreateCoreProjectTypes < ActiveRecord::Migration
  def change
    create_table :core_project_types do |t|
      t.string :name
      t.json :custom_fields

      t.timestamps null: false
    end
  end
end
