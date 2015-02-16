class AddColumnStatusToConceptPost < ActiveRecord::Migration
  def change
  	  	add_column :concept_posts, :status, :integer
  	  	add_index :concept_posts,:status

  end
end
