class AddColorToDiscontentAspect < ActiveRecord::Migration
  def change
    add_column :discontent_aspects, :color, :string
  end
end
