class CreateConceptPosts < ActiveRecord::Migration
  def change
    create_table :concept_posts do |t|
      t.text :goal
      t.text :reality
      t.integer :user_id
      t.integer :number_views
      t.integer :life_tape_post_id

      t.timestamps
    end
    add_index :concept_posts, :user_id
    add_index :concept_posts, :life_tape_post_id
    add_index :concept_posts, :created_at
  end
end
