class RenameModules < ActiveRecord::Migration
  def change
    rename_table :answers, :poll_answers
    rename_table :answers_users, :poll_answers_users
    rename_table :questions, :poll_questions
  end
end
