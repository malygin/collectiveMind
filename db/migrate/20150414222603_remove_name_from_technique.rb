class RemoveNameFromTechnique < ActiveRecord::Migration
  def change
    remove_column :technique_lists, :name, :string
  end
end
