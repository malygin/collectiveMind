class AddAspectIdToDiscontentAspect < ActiveRecord::Migration
  def change
    add_column :core_aspects, :core_aspect_id, :integer
  end
end
