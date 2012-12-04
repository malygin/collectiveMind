class CreateFrustrationEssays < ActiveRecord::Migration
  def change
    create_table :frustration_essays do |t|
      t.integer :user_id
      t.string :content
      t.timestamps
    end
    add_index :frustration_essays, :user_id
  end
end
