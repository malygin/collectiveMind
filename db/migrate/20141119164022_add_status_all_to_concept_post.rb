class AddStatusAllToConceptPost < ActiveRecord::Migration
  def change
    add_column :concept_posts, :status_all, :boolean
  end
end
