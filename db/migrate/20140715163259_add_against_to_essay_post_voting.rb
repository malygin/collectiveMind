class AddAgainstToEssayPostVoting < ActiveRecord::Migration
  def change
    add_column :essay_post_votings, :against, :boolean
  end
end
