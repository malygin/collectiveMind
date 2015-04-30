class AddfullnessToNovations < ActiveRecord::Migration
  def change
    add_column :novation_posts, :fullness, :integer
  end
end
