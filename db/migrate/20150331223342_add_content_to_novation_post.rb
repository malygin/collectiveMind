class AddContentToNovationPost < ActiveRecord::Migration
  def change
    add_column :novation_posts, :content, :text
  end
end
