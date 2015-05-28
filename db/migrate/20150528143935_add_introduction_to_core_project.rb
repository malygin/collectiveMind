class AddIntroductionToCoreProject < ActiveRecord::Migration
  def change
    add_column :core_projects, :introduction, :text
  end
end
