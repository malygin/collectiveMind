class CreateTechniqueStores < ActiveRecord::Migration
  def change
    create_table :technique_stores do |t|
      t.references :technique_list_project, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.integer :post_id
      t.json :params

      t.timestamps null: false
    end
  end
end
