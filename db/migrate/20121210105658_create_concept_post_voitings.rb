class CreateConceptPostVoitings < ActiveRecord::Migration
  def change
    create_table :concept_post_voitings do |t|
      t.integer :user_id
      t.integer :post_id
      t.boolean :against

      t.timestamps
    end
     add_index :concept_post_voitings, :user_id
    add_index :concept_post_voitings, :post_id
    add_index :concept_post_voitings, [:post_id, :user_id]
  end
end
