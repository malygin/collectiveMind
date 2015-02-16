class ChangeAnswer < ActiveRecord::Migration
  def change
    add_column :answers_users, :created_at, :datetime
    add_column :answers_users, :updated_at, :datetime
  end
end
