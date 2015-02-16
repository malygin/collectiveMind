class AddFieldsToConceptPostAspect < ActiveRecord::Migration
  def change
    add_column :concept_post_aspects, :positive, :text
    add_column :concept_post_aspects, :negative, :text
    add_column :concept_post_aspects, :control, :text
    add_column :concept_post_aspects, :name, :string
    add_column :concept_post_aspects, :content, :string

  end
end
