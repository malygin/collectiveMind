class CreateDiscontentPostWhens < ActiveRecord::Migration
  def change
    create_table :discontent_post_whens do |t|
      t.string :content
      t.integer :project_id

    end
  end
end
