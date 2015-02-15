class AddShortDescToDiscontentAspect < ActiveRecord::Migration
  def change
    add_column :core_aspects, :short_desc, :text
  end
end
