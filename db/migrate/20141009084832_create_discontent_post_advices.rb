class CreateDiscontentPostAdvices < ActiveRecord::Migration
  def change
    create_table :discontent_post_advices do |t|
      t.text :content
      t.boolean :approved, default: false
      t.references :user, index: true
      t.references :discontent_post, index: true

      t.timestamps
    end
  end
end
