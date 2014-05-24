class AddAspectToLifeTapePostDiscussion < ActiveRecord::Migration
  def change
    add_column :life_tape_post_discussions, :aspect_id, :integer
  end
end
