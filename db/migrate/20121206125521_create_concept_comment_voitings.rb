class CreateConceptCommentVoitings < ActiveRecord::Migration
  def change
    create_table :concept_comment_voitings do |t|
      t.integer :user_id
      t.integer :comment_id

      t.timestamps
    end
     add_index :concept_comment_voitings, [:created_at, :comment_id]

  end
end