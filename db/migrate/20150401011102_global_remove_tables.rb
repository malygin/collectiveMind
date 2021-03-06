class GlobalRemoveTables < ActiveRecord::Migration
  def change
    drop_table :comments
    drop_table :concept_post_aspect_discontents
    drop_table :concept_post_discontent_complites
    drop_table :concept_post_discussions
    drop_table :concept_post_means
    drop_table :concept_post_notes
    drop_table :concept_task_supply_pairs
    drop_table :discontent_aspect_users
    drop_table :discontent_comment_notes
    drop_table :discontent_post_discussions
    drop_table :discontent_post_notes
    drop_table :discontent_post_replaces
    drop_table :estimate_final_voitings
    drop_table :estimate_forecasts
    drop_table :estimate_post_notes
    drop_table :estimate_task_triplets
    drop_table :expert_news_comment_votings
    drop_table :expert_news_comments
    drop_table :expert_news_post_votings
    drop_table :expert_news_posts
    drop_table :frustration_comments
    drop_table :frustration_essays
    drop_table :frustration_forecasts
    drop_table :frustrations
    drop_table :help_answers
    drop_table :help_questions
    drop_table :help_users_answers
    drop_table :life_tape_categories
    drop_table :life_tape_comment_votings
    drop_table :life_tape_comments
    drop_table :life_tape_post_discussions
    drop_table :life_tape_post_votings
    drop_table :life_tape_posts
    drop_table :plan_post_action_resources
    drop_table :plan_post_first_conds
    drop_table :plan_post_means
    drop_table :plan_post_notes
    drop_table :plan_task_triplets
    drop_table :posts
    drop_table :question_comment_votings
    drop_table :question_comments
    drop_table :question_post_votings
    drop_table :question_posts
    drop_table :questions_users
    drop_table :voitings
  end
end
