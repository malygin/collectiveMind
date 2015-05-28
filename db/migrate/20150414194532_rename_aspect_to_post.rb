class RenameAspectToPost < ActiveRecord::Migration
  def change
    rename_table :core_aspects, :core_aspect_posts
  end
end
