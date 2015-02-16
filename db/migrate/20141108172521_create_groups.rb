class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.string :description
      t.references :project, index: true

      t.timestamps
    end
  end
end
