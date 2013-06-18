class AddGoodPostLabelForLifeTape < ActiveRecord::Migration
  def change
  	 add_column :life_tape_posts, :important, :boolean, :default => :false
  end
end
