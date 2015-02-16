class AddCensoredToConcept < ActiveRecord::Migration
  def change
    add_column :concept_posts, :censored, :boolean,  :default => false
    add_column :concept_comments, :censored, :boolean,  :default => false
  end
end
