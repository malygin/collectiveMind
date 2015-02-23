class ChangeFieldsConcept < ActiveRecord::Migration
  def change
    rename_column :concept_votings, :concept_post_aspect_id, :concept_post_id
    rename_column :plan_post_aspects, :concept_post_aspect_id, :concept_post_id
  end
end
