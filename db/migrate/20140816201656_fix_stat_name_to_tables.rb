class FixStatNameToTables < ActiveRecord::Migration
  def change
    rename_column :life_tape_comments, :dis_stat, :discontent_status
    rename_column :life_tape_comments, :con_stat, :concept_status
    rename_column :life_tape_comments, :discuss_stat, :discuss_status

    rename_column :discontent_comments, :dis_stat, :discontent_status
    rename_column :discontent_comments, :con_stat, :concept_status
    rename_column :discontent_comments, :discuss_stat, :discuss_status

    rename_column :discontent_posts, :imp_comment, :improve_comment
    rename_column :discontent_posts, :imp_stage, :improve_stage
    rename_column :discontent_posts, :discuss_stat, :discuss_status

    rename_column :concept_comments, :dis_stat, :discontent_status
    rename_column :concept_comments, :con_stat, :concept_status
    rename_column :concept_comments, :discuss_stat, :discuss_status

    rename_column :concept_posts, :imp_comment, :improve_comment
    rename_column :concept_posts, :imp_stage, :improve_stage
    rename_column :concept_posts, :discuss_stat, :discuss_status

    rename_column :concept_posts, :stat_name, :status_name
    rename_column :concept_posts, :stat_content, :status_content
    rename_column :concept_posts, :stat_positive, :status_positive
    rename_column :concept_posts, :stat_positive_r, :status_positive_r
    rename_column :concept_posts, :stat_negative, :status_negative
    rename_column :concept_posts, :stat_negative_r, :status_negative_r
    rename_column :concept_posts, :stat_problems, :status_problems
    rename_column :concept_posts, :stat_reality, :status_reality

    rename_column :plan_comments, :dis_stat, :discontent_status
    rename_column :plan_comments, :con_stat, :concept_status
    rename_column :plan_comments, :discuss_stat, :discuss_status

    rename_column :estimate_comments, :dis_stat, :discontent_status
    rename_column :estimate_comments, :con_stat, :concept_status
    rename_column :estimate_comments, :discuss_stat, :discuss_status

    rename_column :essay_comments, :dis_stat, :discontent_status
    rename_column :essay_comments, :con_stat, :concept_status
    rename_column :essay_comments, :discuss_stat, :discuss_status
  end
end
