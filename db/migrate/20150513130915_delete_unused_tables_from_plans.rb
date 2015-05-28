class DeleteUnusedTablesFromPlans < ActiveRecord::Migration
  def change
    drop_table :plan_post_actions if ActiveRecord::Base.connection.table_exists? 'plan_post_actions'
    drop_table :plan_post_stages if ActiveRecord::Base.connection.table_exists? 'plan_post_stages'
    drop_table :plan_post_resources if ActiveRecord::Base.connection.table_exists? 'plan_post_resources'
  end
end
