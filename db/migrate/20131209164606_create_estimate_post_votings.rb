class CreateEstimatePostVotings < ActiveRecord::Migration
  def change
    create_table :estimate_votings do |t|
      t.integer :user_id
      t.integer :estimate_post_id

      t.timestamps
    end
    add_index :estimate_votings, :user_id
    add_index :estimate_votings, :estimate_post_id
  end
end
