class AddDiscussStatToPost < ActiveRecord::Migration
  def change
    add_column :discontent_posts, :discuss_stat, :boolean
    add_column :concept_posts, :discuss_stat, :boolean
  end
end
