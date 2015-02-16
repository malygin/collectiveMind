class CreateKnowbasePosts < ActiveRecord::Migration
  def change
    create_table :knowbase_posts do |t|
      t.text :content
      t.integer :project_id
      t.integer :stage
      t.string :title
      t.timestamps
    end
  end
end
