class AddFormatToJournalLogger < ActiveRecord::Migration
  def change
    add_column :journal_loggers, :request_format, :string
  end
end
