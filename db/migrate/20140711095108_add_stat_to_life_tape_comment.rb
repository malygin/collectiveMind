class AddStatToLifeTapeComment < ActiveRecord::Migration
  def change
    add_column :life_tape_comments, :dis_stat, :boolean
    add_column :life_tape_comments, :con_stat, :boolean
  end
end
