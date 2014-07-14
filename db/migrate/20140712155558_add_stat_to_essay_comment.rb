class AddStatToEssayComment < ActiveRecord::Migration
  def change
    add_column :essay_comments, :dis_stat, :integer
    add_column :essay_comments, :con_stat, :integer
  end
end
