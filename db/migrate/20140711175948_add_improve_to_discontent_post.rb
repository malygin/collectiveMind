class AddImproveToDiscontentPost < ActiveRecord::Migration
  def change
    add_column :discontent_posts, :imp_comment, :integer
    add_column :discontent_posts, :imp_stage, :integer
  end
end
