class CreateTableGroupChat < ActiveRecord::Migration
  def change
    create_table :group_chat_messages do |t|
      t.references :group, index: true
      t.references :user, index: true
      t.string :content
      t.timestamps
    end
  end
end
