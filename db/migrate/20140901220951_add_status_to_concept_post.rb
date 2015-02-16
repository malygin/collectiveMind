class AddStatusToConceptPost < ActiveRecord::Migration
  def change
    add_column :concept_posts, :status_positive_s, :boolean
    add_column :concept_posts, :status_negative_s, :boolean
    add_column :concept_posts, :status_control, :boolean
    add_column :concept_posts, :status_control_r, :boolean
    add_column :concept_posts, :status_control_s, :boolean
    add_column :concept_posts, :status_obstacles, :boolean
  end
end
