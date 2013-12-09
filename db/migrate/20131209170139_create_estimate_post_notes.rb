class CreateEstimatePostNotes < ActiveRecord::Migration
  def change

      create_table :estimate_post_notes do |t|
        t.integer :post_id
        t.integer :user_id
        t.text :content

        t.timestamps
      end

  end
end
