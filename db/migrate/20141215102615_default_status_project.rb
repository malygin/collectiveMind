class DefaultStatusProject < ActiveRecord::Migration
  def change
    change_column :core_projects, :status, :integer, default: Core::Project::STATUS_CODES[:collect_info]
  end
end
