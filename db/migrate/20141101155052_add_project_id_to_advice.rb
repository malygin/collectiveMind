class AddProjectIdToAdvice < ActiveRecord::Migration
  def up
    add_column :advices, :project_id, :integer
    if Advice.any?
      Advice.includes(:adviseable).each do |advice|
        advice.project_id = advice.adviseable.project_id
        advice.save
      end
    end
    change_column :advices, :project_id, :integer, null: false
  end

  def down
    remove_column :advices, :project_id
  end
end
