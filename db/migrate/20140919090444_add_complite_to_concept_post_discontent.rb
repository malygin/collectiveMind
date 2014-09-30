class AddCompliteToConceptPostDiscontent < ActiveRecord::Migration
  def change
    add_column :concept_post_discontents, :complite, :integer
  end
end
