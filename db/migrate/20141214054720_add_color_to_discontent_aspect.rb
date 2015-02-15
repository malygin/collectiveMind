class AddColorToDiscontentAspect < ActiveRecord::Migration
  def change
    add_column :core_aspects, :color, :string
  end
end
