class FixColumnNameTypeForJournals < ActiveRecord::Migration
  def change
  	rename_column :journals, :type, :type_event
  end
end
