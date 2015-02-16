class AddTypeAndLogoToCoreProjects < ActiveRecord::Migration
  def change
    add_column :core_projects, :url_logo, :string
    add_column :core_projects, :type_access, :integer
  end
end
