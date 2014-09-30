class AddStatusToConceptPostDiscontent < ActiveRecord::Migration
  def change
    add_column :concept_post_discontents, :status, :integer
  end
end
