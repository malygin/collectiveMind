class AddStatusToLifeTapePosts < ActiveRecord::Migration
  def change
    add_column :life_tape_posts, :status, :integer, :default =>0

  end
end
