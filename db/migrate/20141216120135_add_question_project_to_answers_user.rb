class AddQuestionProjectToAnswersUser < ActiveRecord::Migration
  def change
    add_column :answers_users, :project_id, :integer
    add_column :answers_users, :question_id, :integer
  end
end
