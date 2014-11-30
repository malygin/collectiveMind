class AddAspectIdToDiscontentAspect < ActiveRecord::Migration
  def change
    add_column :discontent_aspects, :discontent_aspect_id, :integer
  end
end
