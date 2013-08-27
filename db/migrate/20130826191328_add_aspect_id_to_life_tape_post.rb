class AddAspectIdToLifeTapePost < ActiveRecord::Migration
  def change
    add_column :life_tape_posts, :aspect_id, :integer
  end
end
