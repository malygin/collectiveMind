class AddIndeciesToPosts < ActiveRecord::Migration
  def change
    add_index :life_tape_posts, [:project_id, :status]
    add_index :discontent_posts, [:project_id, :status]
    add_index :concept_posts, [:project_id, :status]
    add_index :plan_posts, [:project_id, :status]
  end
end
