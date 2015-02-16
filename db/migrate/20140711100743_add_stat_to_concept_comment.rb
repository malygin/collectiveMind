class AddStatToConceptComment < ActiveRecord::Migration
  def change
    add_column :concept_comments, :dis_stat, :boolean
    add_column :concept_comments, :con_stat, :boolean
  end
end
