class AddFieldToConcept < ActiveRecord::Migration
  def change
    add_column :concept_post_aspects, :obstacles, :text
  end
end
