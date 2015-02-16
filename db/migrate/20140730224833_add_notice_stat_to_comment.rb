class AddNoticeStatToComment < ActiveRecord::Migration
  def change
    add_column :life_tape_comments, :discuss_stat, :boolean
    add_column :discontent_comments, :discuss_stat, :boolean
    add_column :concept_comments, :discuss_stat, :boolean
    add_column :plan_comments, :discuss_stat, :boolean
    add_column :estimate_comments, :discuss_stat, :boolean
    add_column :essay_comments, :discuss_stat, :boolean
  end
end
