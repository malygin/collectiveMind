class CreateHelpUsersAnswers < ActiveRecord::Migration
  def change
    create_table :help_users_answers do |t|
      t.integer :user_id
      t.integer :answer_id

      t.timestamps
    end
  end
end
