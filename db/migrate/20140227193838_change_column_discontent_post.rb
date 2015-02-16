class ChangeColumnDiscontentPost < ActiveRecord::Migration
  def change
    change_column :discontent_posts, :status, :integer, :default =>0


  end
end
