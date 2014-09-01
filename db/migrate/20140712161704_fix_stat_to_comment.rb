class FixStatToComment < ActiveRecord::Migration
  def change
    change_column :plan_comments, :dis_stat, 'boolean USING CAST(dis_stat AS boolean)'
    change_column :plan_comments, :con_stat, 'boolean USING CAST(con_stat AS boolean)'
    change_column :estimate_comments, :dis_stat, 'boolean USING CAST(dis_stat AS boolean)'
    change_column :estimate_comments, :con_stat, 'boolean USING CAST(con_stat AS boolean)'

    change_column :essay_comments, :dis_stat, 'boolean USING CAST(dis_stat AS boolean)'
    change_column :essay_comments, :con_stat, 'boolean USING CAST(con_stat AS boolean)'
  end
end
