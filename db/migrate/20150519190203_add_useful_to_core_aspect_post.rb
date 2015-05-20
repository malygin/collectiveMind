class AddUsefulToCoreAspectPost < ActiveRecord::Migration
  def change
    add_column :core_aspect_posts, :useful, :boolean
  end
end
