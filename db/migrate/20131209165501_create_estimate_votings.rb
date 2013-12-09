class CreateEstimateVotings < ActiveRecord::Migration
  def change
    create_table :estimate_post_votings do |t|
      t.integer :user_id
      t.integer :post_id
      t.boolean :against

      t.timestamps
    end
    add_index :estimate_post_votings, :user_id
    add_index :estimate_post_votings, :post_id
    add_index :estimate_post_votings, [:post_id, :user_id]
  end
end
