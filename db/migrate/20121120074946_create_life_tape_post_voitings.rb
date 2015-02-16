class CreateLifeTapePostVoitings < ActiveRecord::Migration
  def change
    create_table :life_tape_post_voitings do |t|
      t.integer :user_id
      t.integer :post_id
      t.boolean :against, :default => true
      t.timestamps
    end
    add_index :life_tape_post_voitings, :user_id
    add_index :life_tape_post_voitings, :post_id
    add_index :life_tape_post_voitings, [:post_id, :user_id]
  end
end
