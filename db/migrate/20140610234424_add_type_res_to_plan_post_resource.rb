class AddTypeResToPlanPostResource < ActiveRecord::Migration
  def change
    add_column :plan_post_resources, :type_res, :string
  end
end
