class CreateConceptPostMeans < ActiveRecord::Migration
  def change
    create_table :concept_post_means do |t|
      t.string :name
      t.text :desc
      t.integer :post_id
      t.integer :resource_id
      t.string :type_res

      t.timestamps
    end
  end
end
