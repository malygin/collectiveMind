class AddImportantForEstimatePostAspect < ActiveRecord::Migration
  def change
    add_column :estimate_post_aspects, :imp, :integer

  end
end
