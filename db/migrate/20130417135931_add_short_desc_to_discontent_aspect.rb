class AddShortDescToDiscontentAspect < ActiveRecord::Migration
  def change
    add_column :discontent_aspects, :short_desc, :text
  end
end
