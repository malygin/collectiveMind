class AddDiscontentToConceptVoting < ActiveRecord::Migration
  def change
    add_column :concept_votings, :discontent_post_id, :integer
  end
end
