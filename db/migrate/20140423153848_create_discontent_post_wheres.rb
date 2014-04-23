class CreateDiscontentPostWheres < ActiveRecord::Migration
  def change
    create_table :discontent_post_wheres do |t|
      t.string :content
      t.integer :project_id

    end
  end
end
