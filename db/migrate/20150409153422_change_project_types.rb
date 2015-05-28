class ChangeProjectTypes < ActiveRecord::Migration
  def change
    remove_column :core_project_types, :custom_fields, :json
    add_column :core_project_types, :code, :string
    add_column :core_project_types, :custom_fields, :boolean, default: false
  end
end
