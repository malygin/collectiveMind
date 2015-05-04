class AddusefulToNovations < ActiveRecord::Migration
  def change
    add_column :novation_posts, :useful, :boolean
  end
end
