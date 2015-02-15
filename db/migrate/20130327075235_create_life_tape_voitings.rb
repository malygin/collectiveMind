class CreateLifeTapeVoitings < ActiveRecord::Migration
  def change
    create_table :life_tape_voitings do |t|
      t.integer :user_id
      t.integer :discontent_aspect_id

      t.timestamps
    end
        add_index :life_tape_voitings, :user_id
        add_index :life_tape_voitings, :discontent_aspect_id

  end
end
