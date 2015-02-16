class AddColorToCoreProject < ActiveRecord::Migration
  def change
    add_column :core_projects, :color, :string
  end
end
