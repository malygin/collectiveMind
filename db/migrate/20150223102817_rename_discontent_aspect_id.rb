class RenameDiscontentAspectId < ActiveRecord::Migration
  def change
    rename_column :concept_post_aspects, :discontent_aspect_id, :core_aspect_id
    rename_column :plan_post_aspects, :discontent_aspect_id, :core_aspect_id
  end
end
