class RenameCollectInfoToAspect < ActiveRecord::Migration
  def change
    rename_column :core_aspect_posts, :core_aspect_id, :aspect_id
    rename_column :core_project_users, :collect_info_posts_score, :aspect_posts_score

    rename_table :collect_info_answers, :aspect_answers
    rename_table :collect_info_questions, :aspect_questions
    rename_table :collect_info_user_answers, :aspect_user_answers
    rename_table :collect_info_votings, :aspect_votings
    rename_table :core_aspect_comment_votings, :aspect_comment_votings
    rename_table :core_aspect_comments, :aspect_comments
    rename_table :core_aspect_post_votings, :aspect_post_votings
    rename_table :core_aspect_posts, :aspect_posts
  end
end
