class CreateDiscontentPostAspects < ActiveRecord::Migration
  def change
    create_table :discontent_post_aspects do |t|
      t.integer :post_id
      t.integer :aspect_id

      t.timestamps
    end
  end
end
