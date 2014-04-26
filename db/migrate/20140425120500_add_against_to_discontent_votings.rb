class AddAgainstToDiscontentVotings < ActiveRecord::Migration
  def change
    add_column :discontent_votings, :against, :boolean
  end
end
