class AddPostiveResourceNeagtiveRecosurceConceptPostAspect < ActiveRecord::Migration
  def change
    add_column :concept_post_aspects, :positive_r, :text
    add_column :concept_post_aspects, :negative_r, :text
  end

end
