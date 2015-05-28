class AddTasksToPlan < ActiveRecord::Migration
  def change
    add_column :plan_posts, :tasks_gant, :json
  end
end
