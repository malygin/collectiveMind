class AddTitleToConceptPostspect < ActiveRecord::Migration
  def change
    add_column :concept_post_aspects, :title, :text
  end
end
