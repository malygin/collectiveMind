class ChangePostConceptVoting < ActiveRecord::Migration
  def change
    rename_column :concept_votings, :concept_post_id, :concept_post_aspect_id
  end
end
