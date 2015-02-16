class AddStatToDiscontentComment < ActiveRecord::Migration
  def change
    add_column :discontent_comments, :dis_stat, :boolean
    add_column :discontent_comments, :con_stat, :boolean
  end
end
