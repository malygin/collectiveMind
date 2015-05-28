class AddDatesCountStages < ActiveRecord::Migration
  def change
    add_column :core_projects, :date_start, :date
    add_column :core_projects, :date_end, :date
    add_column :core_projects, :count_stages, :integer
  end
end
