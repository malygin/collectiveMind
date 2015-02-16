class AddTitleToHelpPost < ActiveRecord::Migration
  def change
    add_column :help_posts, :title, :string
  end
end
