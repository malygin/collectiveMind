class AddImportantToDiscontentPost < ActiveRecord::Migration
  def change
    add_column :discontent_posts, :important, :boolean
  end
end
