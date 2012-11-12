class CreateLifeTapeCategories < ActiveRecord::Migration
  def change
    create_table :life_tape_categories do |t|
      t.string :name
      t.text :short_desc
      t.text :long_desc

      t.timestamps
    end
  end
end
