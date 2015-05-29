class AddTypeAnswerToCollectInfoQuestion < ActiveRecord::Migration
  def change
    add_column :collect_info_questions, :type_comment, :integer
  end
end
