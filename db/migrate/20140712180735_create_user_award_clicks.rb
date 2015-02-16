class CreateUserAwardClicks < ActiveRecord::Migration
  def change
    create_table :user_award_clicks do |t|
      t.integer :user_id
      t.integer :project_id
      t.integer :clicks, default: 0

      t.timestamps
    end
  end
end
