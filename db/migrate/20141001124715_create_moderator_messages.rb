class CreateModeratorMessages < ActiveRecord::Migration
  def change
    create_table :moderator_messages do |t|
      t.references :user, index: true
      t.text :message

      t.timestamps
    end
  end
end
