class CreateConceptPostDiscontentComplites < ActiveRecord::Migration
  def change
    create_table :concept_post_discontent_complites do |t|
      t.integer :post_id
      t.integer :discontent_post_id
      t.integer :complite

      t.timestamps
    end
  end
end
