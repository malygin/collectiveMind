class AddCompletionTextToCoreProject < ActiveRecord::Migration
  def change
    add_column :core_projects, :completion_text, :text
  end
end
