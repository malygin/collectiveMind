class CreateConceptVotings < ActiveRecord::Migration
  def change
    create_table :concept_votings do |t|
      t.integer :user_id
      t.integer :concept_post_id

      t.timestamps
    end
    add_index :concept_votings, :user_id
    add_index :concept_votings, :concept_post_id
  end
end
