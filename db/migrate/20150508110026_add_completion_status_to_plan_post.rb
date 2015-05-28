class AddCompletionStatusToPlanPost < ActiveRecord::Migration
  def change
    add_column :plan_posts, :completion_status, :boolean
  end
end
