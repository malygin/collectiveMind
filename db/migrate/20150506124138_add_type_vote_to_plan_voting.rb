class AddTypeVoteToPlanVoting < ActiveRecord::Migration
  def change
    add_column :plan_votings, :type_vote, :integer
  end
end
