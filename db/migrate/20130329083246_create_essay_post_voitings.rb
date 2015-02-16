class CreateEssayPostVoitings < ActiveRecord::Migration
  def change
    create_table :essay_post_voitings do |t|
      t.integer :user_id
      t.integer :post_id

      t.timestamps
    end
    add_index :essay_post_voitings, :post_id
  end
end
