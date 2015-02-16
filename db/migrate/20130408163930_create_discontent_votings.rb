class CreateDiscontentVotings < ActiveRecord::Migration
  def change
    create_table :discontent_votings do |t|
      t.integer :user_id
      t.integer :discontent_post_id

      t.timestamps
    end
    add_index :discontent_votings, :user_id
    add_index :discontent_votings, :discontent_post_id
  end
end
