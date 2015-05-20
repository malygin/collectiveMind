class AddStageToCoreProject < ActiveRecord::Migration
  def change
    remove_column :core_projects, :stage1
    remove_column :core_projects, :stage2
    remove_column :core_projects, :stage3
    remove_column :core_projects, :stage4
    remove_column :core_projects, :stage5
    remove_column :core_projects, :knowledge
    remove_column :core_projects, :date_12
    remove_column :core_projects, :date_23
    remove_column :core_projects, :date_34
    remove_column :core_projects, :date_45
    remove_column :core_projects, :date_56
    remove_column :core_projects, :secret2
    remove_column :core_projects, :secret3
    remove_column :core_projects, :secret
    remove_column :core_projects, :count_stages
    remove_column :core_projects, :project_type_id


    add_column :core_projects, :stage, :string, default: '1:0'
  end
end
