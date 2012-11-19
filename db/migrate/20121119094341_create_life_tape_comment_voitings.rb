class CreateLifeTapeCommentVoitings < ActiveRecord::Migration
  def change
    create_table :life_tape_comment_voitings do |t|
      t.integer :user_id
      t.integer :comment_id

      t.timestamps
    end
    add_index :life_tape_comment_voitings, [:user_id, :comment_id]

  end
end
