class RemoveAdvices < ActiveRecord::Migration
  def change
    drop_table :advices if ActiveRecord::Base.connection.table_exists? 'advices'
    drop_table :advice_comments if ActiveRecord::Base.connection.table_exists? 'advice_comments'

    remove_column :core_projects, :advices_concept
    remove_column :core_projects, :advices_discontent
  end
end
