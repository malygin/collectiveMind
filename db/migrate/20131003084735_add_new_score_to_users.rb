class AddNewScoreToUsers < ActiveRecord::Migration
  def change
    add_column :users, :score_a, :integer, :default => 0
    add_column :users, :score_g, :integer,  :default => 0
    add_column :users, :score_o, :integer,  :default => 0
  end
end
