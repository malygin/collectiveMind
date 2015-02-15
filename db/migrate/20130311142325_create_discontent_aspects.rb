class CreateDiscontentAspects < ActiveRecord::Migration
  def change
    create_table :core_aspects do |t|
      t.text :content
      t.integer :user_id
      t.integer :position
      t.timestamps
    end
  end
end
