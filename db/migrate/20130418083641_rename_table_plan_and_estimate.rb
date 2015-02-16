class RenameTablePlanAndEstimate < ActiveRecord::Migration
  def change
  	rename_table :plan_post_voitings, :plan_post_votings
  	rename_table :plan_comment_voitings, :plan_comment_votings
  	rename_table :estimate_comment_voitings, :estimate_comment_votings
  end
end
