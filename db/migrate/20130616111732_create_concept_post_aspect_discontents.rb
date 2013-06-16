class CreateConceptPostAspectDiscontents < ActiveRecord::Migration
  def change
    create_table :concept_post_aspect_discontents do |t|
      t.integer :post_aspect_id
      t.string :name
      t.text :content
      t.integer :discontent_post_id
      t.text :positive
      t.text :negative
      t.text :control

      t.timestamps
    end
  end
end
