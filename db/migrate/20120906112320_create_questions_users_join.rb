class CreateQuestionsUsersJoin < ActiveRecord::Migration
  def up
  	create_table 'questions_users', :id => false do |t|
  		t.column 'question_id', :integer
  		t.column 'user_id', :integer
  		t.timestamp

  	end
  	add_index 'questions_users', 'question_id'
    add_index 'questions_users', 'user_id'
  end

  def down
  	drop_table 'questions_users'
  end
end
