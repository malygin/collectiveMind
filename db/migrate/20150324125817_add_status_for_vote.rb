class AddStatusForVote < ActiveRecord::Migration
  def change
    add_column :collect_info_votings, :status, :integer
    add_column :discontent_votings, :status, :integer
    add_column :concept_votings, :status, :integer
    add_column :novation_votings, :status, :integer
    add_column :plan_votings, :status, :integer
    add_column :estimate_votings, :status, :integer
  end
end
