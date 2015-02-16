class CreateAnswersUsersJoin < ActiveRecord::Migration
  def up
  		create_table 'answers_users', :id => false do |t|
  		t.column 'answer_id', :integer
  		t.column 'user_id', :integer
  		t.timestamp
  	end
  	add_index 'answers_users', 'answer_id'
    add_index 'answers_users', 'user_id'
  end

  def down
  end
end
