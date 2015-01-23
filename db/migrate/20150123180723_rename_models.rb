class RenameModels < ActiveRecord::Migration
  def change
    rename_table :help_posts, :core_help_posts
    rename_table :essay_posts, :core_essay_posts
    rename_table :essay_comments, :core_essay_comments
    rename_table :essay_post_votings, :core_essay_post_votings
    rename_table :discontent_aspects, :core_aspects
  end
end
