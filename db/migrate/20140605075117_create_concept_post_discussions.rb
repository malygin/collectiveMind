class CreateConceptPostDiscussions < ActiveRecord::Migration
  def change
    create_table :concept_post_discussions do |t|
      t.integer :user_id
      t.integer :discontent_post_id
      t.integer :post_id

      t.timestamps
    end
  end
end