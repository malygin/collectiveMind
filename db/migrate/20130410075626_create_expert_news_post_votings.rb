class CreateExpertNewsPostVotings < ActiveRecord::Migration
  def change
    create_table :expert_news_post_votings do |t|
      t.integer :post_id
      t.integer :user_id

      t.timestamps
    end
    add_index :expert_news_post_votings, :post_id
  end
end
