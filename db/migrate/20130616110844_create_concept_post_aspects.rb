class CreateConceptPostAspects < ActiveRecord::Migration
  def change
    create_table :concept_post_aspects do |t|
      t.integer :discontent_aspect_id
      t.integer :concept_post_id

      t.timestamps
    end
  end
end
