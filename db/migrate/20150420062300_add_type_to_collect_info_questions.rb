class AddTypeToCollectInfoQuestions < ActiveRecord::Migration
  def change
    add_column :collect_info_questions, :type_stage, :integer
  end
end
