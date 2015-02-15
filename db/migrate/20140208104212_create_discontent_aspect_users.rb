class CreateDiscontentAspectUsers < ActiveRecord::Migration
  def change
    create_table :core_aspect_users do |t|
      t.integer :user_id
      t.integer :aspect_id

      t.timestamps
    end
    add_index  :core_aspect_users, :user_id

  end
end
