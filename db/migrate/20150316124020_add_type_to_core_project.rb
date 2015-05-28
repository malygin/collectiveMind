class AddTypeToCoreProject < ActiveRecord::Migration
  def change
    add_column :core_projects, :type_procedure, :integer
  end
end
