class ChangeColumnNameForDiscontentPostWhenWhere < ActiveRecord::Migration
  def change
    rename_column :discontent_posts, :when, :whend
    rename_column :discontent_posts, :where, :whered
  end
end
