class CreateConceptPostDiscontents < ActiveRecord::Migration
  def change
    create_table :concept_post_discontents do |t|
      t.integer :post_id
      t.integer :discontent_post_id

      t.timestamps
    end
  end
end
