class AddDefaultValueForCoreProjectScore < ActiveRecord::Migration
  def change
    change_column :core_project_scores, :score, :integer, default: 0
    change_column :core_project_scores, :score_a, :integer, default: 0
    change_column :core_project_scores, :score_g, :integer, default: 0
    change_column :core_project_scores, :score_o, :integer, default: 0

  end
end
