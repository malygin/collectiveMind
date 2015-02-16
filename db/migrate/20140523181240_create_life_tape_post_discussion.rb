class CreateLifeTapePostDiscussion < ActiveRecord::Migration
  def change
    create_table :life_tape_post_discussions do |t|
      t.integer :user_id
      t.integer :post_id

      t.timestamps
    end
  end
end
