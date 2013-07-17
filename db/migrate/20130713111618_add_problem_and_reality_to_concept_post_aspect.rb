class AddProblemAndRealityToConceptPostAspect < ActiveRecord::Migration
  def change
    add_column :concept_post_aspects, :reality, :text
    add_column :concept_post_aspects, :problems, :text
  end
end
