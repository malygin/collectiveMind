class RemoveUnusedFieldsFromConcepts < ActiveRecord::Migration
  def change
    remove_column :concept_posts, :life_tape_post_id, :integer
    remove_column :concept_posts, :status_name, :boolean
    remove_column :concept_posts, :status_content, :boolean
    remove_column :concept_posts, :status_positive, :boolean
    remove_column :concept_posts, :status_positive_r, :boolean
    remove_column :concept_posts, :status_negative, :boolean
    remove_column :concept_posts, :status_negative_r, :boolean
    remove_column :concept_posts, :status_problems, :boolean
    remove_column :concept_posts, :status_reality, :boolean
    remove_column :concept_posts, :status_positive_s, :boolean
    remove_column :concept_posts, :status_negative_s, :boolean
    remove_column :concept_posts, :status_control, :boolean
    remove_column :concept_posts, :status_control_r, :boolean
    remove_column :concept_posts, :status_control_s, :boolean
    remove_column :concept_posts, :status_obstacles, :boolean
    remove_column :concept_posts, :positive, :text
    remove_column :concept_posts, :negative, :text
    remove_column :concept_posts, :positive_r, :text
    remove_column :concept_posts, :negative_r, :text
    remove_column :concept_posts, :reality, :text
    remove_column :concept_posts, :core_aspect_id, :text
    remove_column :concept_posts, :control, :text
    remove_column :concept_posts, :problems, :text
    remove_column :concept_posts, :obstacles, :text
    remove_column :concept_posts, :actions_desc, :text
    remove_column :concept_posts, :actions_ground, :text
    remove_column :concept_posts, :tools, :text
    remove_column :concept_posts, :impact_group, :text
    remove_column :concept_posts, :improve_comment, :text
    remove_column :concept_posts, :improve_stage, :text
    remove_column :concept_posts, :fullness, :text
    remove_column :concept_posts, :status_all, :text
    remove_column :concept_posts, :name, :text
  end
end
