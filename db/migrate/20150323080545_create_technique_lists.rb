class CreateTechniqueLists < ActiveRecord::Migration
  def change
    create_table :technique_lists do |t|
      t.string :name
      t.string :stage
      t.string :code

      t.timestamps null: false
    end
  end
end
