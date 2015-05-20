class DefaultStatusProject < ActiveRecord::Migration
  def change
    change_column :core_projects, :status, :integer, default: 1
  end
end
