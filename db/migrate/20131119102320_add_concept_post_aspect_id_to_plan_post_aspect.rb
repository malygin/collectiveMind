class AddConceptPostAspectIdToPlanPostAspect < ActiveRecord::Migration
  def change
    add_column :plan_post_aspects, :concept_post_aspect_id, :integer
  end
end
