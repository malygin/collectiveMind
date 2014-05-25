class CreateDiscontentNotes < ActiveRecord::Migration
  def change
    create_table :discontent_notes do |t|
      t.text :content
      t.integer :user_id
      t.integer :post_id
      t.integer :type_field

      t.timestamps
    end
  end
end