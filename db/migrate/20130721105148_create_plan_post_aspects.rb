class CreatePlanPostAspects < ActiveRecord::Migration
  def change
    create_table :plan_post_aspects do |t|
      t.integer :core_aspect_id
      t.integer :concept_post_id
      t.text :positive
      t.text :negative
      t.text :control
      t.text :problems
      t.text :reality
      t.boolean :first_stage
      t.string :name
      t.string  :content
      t.timestamps
    end
  end
end
