class AddNewFieldsToConcept < ActiveRecord::Migration
  def change
    add_column :concept_posts, :actions_desc, :text
    add_column :concept_posts, :actions_ground, :text
    add_column :concept_posts, :actors, :text
    add_column :concept_posts, :tools, :text
    add_column :concept_posts, :impact_group, :text
    add_column :concept_posts, :impact_env, :text
  end
end
