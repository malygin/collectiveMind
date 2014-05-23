class AddDiscontentAspectToKnowBasePost < ActiveRecord::Migration
  def change
    add_column :knowbase_posts, :aspect_id, :integer
  end
end
