class CreateExpertNewsComments < ActiveRecord::Migration
  def change
    create_table :expert_news_comments do |t|
      t.integer :user_id
      t.integer :post_id
      t.text :content

      t.timestamps
    end
    add_index :expert_news_comments, :post_id
  end
end
