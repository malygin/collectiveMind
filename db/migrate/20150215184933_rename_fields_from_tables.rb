class RenameFieldsFromTables < ActiveRecord::Migration
  def change
    rename_column :core_aspects, :discontent_aspect_id, :core_aspect_id
  end
end
