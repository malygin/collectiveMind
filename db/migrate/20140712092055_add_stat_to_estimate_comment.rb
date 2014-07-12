class AddStatToEstimateComment < ActiveRecord::Migration
  def change
    add_column :estimate_comments, :dis_stat, :integer
    add_column :estimate_comments, :con_stat, :integer
  end
end
