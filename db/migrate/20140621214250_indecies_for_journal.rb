class IndeciesForJournal < ActiveRecord::Migration
  def change
    add_index :journals, [:project_id, :type_event, :user_informed, :viewed ], name: "pr_te_ui_viewd"
  end
end
