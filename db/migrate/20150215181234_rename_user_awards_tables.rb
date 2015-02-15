class RenameUserAwardsTables < ActiveRecord::Migration
  def change
    rename_table :user_awards, :core_user_awards
    rename_table :user_award_clicks, :core_user_award_clicks
  end
end
