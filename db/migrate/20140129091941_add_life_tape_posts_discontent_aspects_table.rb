class AddLifeTapePostsDiscontentAspectsTable < ActiveRecord::Migration
  def change
    create_table :discontent_aspects_life_tape_posts do |t|
      t.integer :discontent_aspect_id
      t.integer :life_tape_post_id
    end
    add_index  :discontent_aspects_life_tape_posts, [:discontent_aspect_id, :life_tape_post_id], name: 'index_discontent_aspects_life_tape_posts'

  end
end
