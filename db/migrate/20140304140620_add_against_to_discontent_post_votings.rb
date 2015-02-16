class AddAgainstToDiscontentPostVotings < ActiveRecord::Migration
  def change
    add_column :discontent_post_votings, :against, :boolean, :default => true
  end
end
