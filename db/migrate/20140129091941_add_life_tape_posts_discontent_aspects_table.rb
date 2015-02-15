class AddLifeTapePostsDiscontentAspectsTable < ActiveRecord::Migration
  def change
    create_table :core_aspects_life_tape_posts do |t|
      t.integer :core_aspect_id
      t.integer :life_tape_post_id
    end
    add_index  :core_aspects_life_tape_posts, [:core_aspect_id, :life_tape_post_id], name: 'index_core_aspects_life_tape_posts'

  end
end
