class CreateExpertNewsPosts < ActiveRecord::Migration
  def change
    create_table :expert_news_posts do |t|
      t.string :title
      t.text :anons
      t.text :content
      t.integer :user_id

      t.timestamps
    end
    add_index :expert_news_posts, :created_at
  end
end
