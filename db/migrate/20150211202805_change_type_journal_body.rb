class ChangeTypeJournalBody < ActiveRecord::Migration
  def up
    change_column :journals, :body, :text
  end

  def down
    change_column :journals, :body, :string
  end
end
