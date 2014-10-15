class ChangePostToPostableInAdvices < ActiveRecord::Migration
  def change
    remove_column :advices, :discontent_post_id, :integer
    change_table :advices do |t|
      t.references :adviseable, polymorphic: true, null: false
    end
  end
end
