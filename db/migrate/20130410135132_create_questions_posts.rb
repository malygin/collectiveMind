class CreateQuestionsPosts < ActiveRecord::Migration
  def change
    create_table :questions_posts do |t|
      t.integer :user_id
      t.integer :project_id
      t.text :content
      t.integer :status

      t.timestamps
    end
    add_index :questions_posts, :project_id
  end
end
