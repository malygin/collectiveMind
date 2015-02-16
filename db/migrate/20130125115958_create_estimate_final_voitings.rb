class CreateEstimateFinalVoitings < ActiveRecord::Migration
  def change
    create_table :estimate_final_voitings do |t|
      t.integer :user_id
      t.integer :post_id
      t.integer :score

      t.timestamps
    end
    add_index :estimate_final_voitings,:user_id

  end
end
