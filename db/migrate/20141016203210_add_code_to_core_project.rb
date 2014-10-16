class AddCodeToCoreProject < ActiveRecord::Migration
  def change
    add_column :core_projects, :code, :string
  end
end
