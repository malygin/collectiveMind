class CreateEssayPosts < ActiveRecord::Migration
  def change
    create_table :essay_posts do |t|
      t.integer :user_id
      t.integer :project_id
      t.text :content
      t.integer :status
      t.integer :stage

      t.timestamps
    end
  end
end
