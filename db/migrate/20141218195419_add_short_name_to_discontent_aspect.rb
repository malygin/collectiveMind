class AddShortNameToDiscontentAspect < ActiveRecord::Migration
  def change
    add_column :core_aspects, :short_name, :string
  end
end
