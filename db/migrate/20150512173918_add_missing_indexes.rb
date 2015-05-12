class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :concept_votings, :discontent_post_id
    add_index :concept_votings, [:concept_post_id, :user_id]
    add_index :concept_resources, :project_id
    add_index :core_user_awards, :award_id
    add_index :core_user_awards, :project_id
    add_index :core_user_awards, :user_id
    add_index :core_user_awards, [:award_id, :user_id]
    add_index :concept_post_votings, [:post_id, :user_id]
    add_index :concept_comment_votings, :user_id
    add_index :concept_comment_votings, [:comment_id, :user_id]
    add_index :discontent_post_whens, :project_id
    add_index :core_aspect_comments, :user_id
    add_index :core_aspect_comments, :post_id
    add_index :core_aspect_comments, :comment_id
    add_index :core_aspect_comment_votings, [:comment_id, :user_id]
    add_index :core_aspect_comment_votings, :user_id
    add_index :core_aspect_comment_votings, :comment_id
    add_index :concept_post_resources, :post_id
    add_index :concept_post_resources, :project_id
    add_index :concept_post_discontents, :post_id
    add_index :concept_post_discontents, :discontent_post_id
    add_index :concept_post_discontents, [:post_id, :discontent_post_id], :name => 'concept_post_discontents_post_discontent'
    add_index :discontent_comments, :user_id
    add_index :discontent_comments, :post_id
    add_index :discontent_comments, :comment_id
    add_index :discontent_comment_votings, [:comment_id, :user_id]
    add_index :discontent_comment_votings, :user_id
    add_index :discontent_post_aspects, :post_id
    add_index :discontent_post_aspects, :aspect_id
    add_index :discontent_post_aspects, [:aspect_id, :post_id]
    add_index :discontent_post_votings, [:post_id, :user_id]
    add_index :collect_info_questions, :project_id
    add_index :collect_info_questions, :aspect_id
    add_index :collect_info_answers, :question_id
    add_index :discontent_post_wheres, :project_id
    add_index :discontent_votings, [:discontent_post_id, :user_id]
    add_index :advices, [:adviseable_id, :adviseable_type]
    add_index :advices, :project_id
    add_index :core_project_scores, :project_id
    add_index :core_project_scores, :user_id
    add_index :concept_comments, :comment_id
    add_index :collect_info_votings, [:aspect_id, :user_id]
    add_index :discontent_notes, :user_id
    add_index :discontent_notes, :post_id
    add_index :estimate_comments, :user_id
    add_index :estimate_comments, :comment_id
    add_index :estimate_comment_votings, [:comment_id, :user_id]
    add_index :estimate_comment_votings, :user_id
    add_index :novation_posts, :user_id
    add_index :novation_posts, :project_id
    add_index :novation_post_votings, [:post_id, :user_id]
    add_index :novation_post_votings, :user_id
    add_index :novation_post_votings, :post_id
    add_index :novation_votings, [:novation_post_id, :user_id]
    add_index :novation_votings, :user_id
    add_index :novation_votings, :novation_post_id
    add_index :novation_post_concepts, [:concept_post_id, :post_id]
    add_index :novation_post_concepts, :post_id
    add_index :novation_post_concepts, :concept_post_id
    add_index :core_essay_comments, :user_id
    add_index :core_essay_comments, :comment_id
    add_index :core_essay_comment_votings, [:comment_id, :user_id]
    add_index :core_essay_comment_votings, :user_id
    add_index :core_content_user_answers, :user_id
    add_index :core_content_user_answers, :content_answer_id
    add_index :core_content_user_answers, :content_question_id
    add_index :core_content_questions, :project_id
    add_index :core_aspect_post_votings, :user_id
    add_index :core_aspect_post_votings, :post_id
    add_index :core_aspect_post_votings, [:post_id, :user_id]
    add_index :core_project_users, [:project_id, :user_id]
    add_index :core_user_award_clicks, :user_id
    add_index :core_user_award_clicks, :project_id
    add_index :concept_notes, :user_id
    add_index :concept_notes, :post_id
    add_index :discontent_posts, :user_id
    add_index :discontent_posts, :discontent_post_id
    add_index :plan_comments, :user_id
    add_index :plan_comments, :comment_id
    add_index :plan_comment_votings, [:comment_id, :user_id]
    add_index :plan_comment_votings, :user_id
    add_index :user_checks, :user_id
    add_index :plan_votings, [:plan_post_id, :user_id]
    add_index :plan_votings, :user_id
    add_index :plan_votings, :plan_post_id
    add_index :core_projects, :project_type_id
    add_index :technique_list_projects, [:project_id, :technique_list_id], :name => 'technique_list_projects_project_list'
    add_index :novation_comment_votings, :user_id
    add_index :novation_comment_votings, :comment_id
    add_index :novation_comment_votings, [:comment_id, :user_id]
    add_index :plan_notes, :user_id
    add_index :plan_notes, :post_id
    add_index :plan_post_votings, [:post_id, :user_id]
    add_index :plan_post_votings, :user_id
    add_index :plan_post_novations, :novation_post_id
    add_index :plan_post_novations, :plan_post_id
    add_index :core_aspect_posts, :user_id
    add_index :core_aspect_posts, :core_aspect_id
    add_index :plan_post_actions, :plan_post_aspect_id
    add_index :estimate_post_aspects, :post_id
    add_index :estimate_post_aspects, :plan_post_aspect_id
    add_index :core_knowbase_posts, :project_id
    add_index :core_knowbase_posts, :aspect_id
    add_index :journal_loggers, :user_id
    add_index :journal_loggers, :user_informed
    add_index :journal_loggers, :project_id
    add_index :core_essay_post_votings, :user_id
    add_index :core_essay_post_votings, [:post_id, :user_id]
    add_index :journal_mailers, :user_id
    add_index :journal_mailers, :project_id
    add_index :novation_comments, :user_id
    add_index :novation_comments, :post_id
    add_index :novation_comments, :comment_id
    add_index :core_essay_posts, :user_id
    add_index :core_essay_posts, :project_id
    add_index :novation_notes, :user_id
    add_index :novation_notes, :post_id
    add_index :plan_post_resources, :project_id
    add_index :plan_post_resources, :post_id
    add_index :plan_post_stages, :post_id
  end
end