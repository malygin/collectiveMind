class RenameTables < ActiveRecord::Migration
  def change
    rename_table :knowbase_posts, :core_knowbase_posts
    rename_table :help_posts, :core_help_posts
    rename_table :essay_posts, :core_essay_posts
    rename_table :essay_comments, :core_essay_comments
    rename_table :essay_post_votings, :core_essay_post_votings
    rename_table :core_aspects, :core_aspects
    rename_table :answers, :collect_info_answers
    rename_table :answers_users, :collect_info_answers_users
    rename_table :questions, :collect_info_questions
    rename_table :life_tape_voitings, :collect_info_votings
  end
end
