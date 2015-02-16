class AddStatToPlanComment < ActiveRecord::Migration
  def change
    add_column :plan_comments, :dis_stat, :integer
    add_column :plan_comments, :con_stat, :integer
  end
end
