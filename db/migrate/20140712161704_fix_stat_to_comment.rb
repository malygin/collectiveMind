class FixStatToComment < ActiveRecord::Migration
  def change
    change_column :plan_comments, :dis_stat, :boolean
    change_column :plan_comments, :con_stat, :boolean
    change_column :estimate_comments, :dis_stat, :boolean
    change_column :estimate_comments, :con_stat, :boolean

    change_column :essay_comments, :dis_stat, :boolean
    change_column :essay_comments, :con_stat, :boolean
  end
end
