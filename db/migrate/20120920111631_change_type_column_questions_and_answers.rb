class ChangeTypeColumnQuestionsAndAnswers < ActiveRecord::Migration
 def up
  	change_column :test_questions, :name, :text, :limit => nil
  	change_column :test_answers, :name, :text, :limit => nil
  end

  def down
  	change_column :test_questions, :name, :string,:limit => nil
  	change_column :test_answers, :name, :string, :limit => nil
  end
end
