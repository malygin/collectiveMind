class AddOrderToTestQuestion < ActiveRecord::Migration
  def change
  	add_column :test_questions, :order_question, :integer
  	add_index :test_questions, :order_question
  end
end
