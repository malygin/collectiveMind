class CreateJournalMailers < ActiveRecord::Migration
  def change
    create_table :journal_mailers do |t|
      t.string :title
      t.text :content
      t.integer :user_id
      t.integer :project_id
      t.integer :status
      t.boolean :sent
      t.boolean :viewed, default: false
      t.boolean :visible, default: true
      t.integer :receiver
      t.integer :group_id

      t.timestamps
    end
  end
end
