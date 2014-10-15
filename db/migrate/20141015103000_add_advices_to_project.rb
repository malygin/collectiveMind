class AddAdvicesToProject < ActiveRecord::Migration
  def change
    add_column :core_projects, :advices_discontent, :boolean
    add_column :core_projects, :advices_concept, :boolean
  end
end
