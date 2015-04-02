class FixEssayAndDiscontent < ActiveRecord::Migration
  def change
    drop_table :discontent_aspects_life_tape_posts
    rename_table :essay_comment_votings, :core_essay_comment_votings
  end
end
