class DeleteUnusedDbs < ActiveRecord::Migration
  def change
    if ActiveRecord::Base.connection.table_exists? 'concept_essays'
      drop_table :concept_essays
    end
    if ActiveRecord::Base.connection.table_exists? 'concept_final_voitings'
      drop_table :concept_final_voitings
    end
    if ActiveRecord::Base.connection.table_exists? 'concept_forecast_tasks'
      drop_table :concept_forecast_tasks
    end
    if ActiveRecord::Base.connection.table_exists? 'concept_forecasts'
      drop_table :concept_forecasts
    end
    if ActiveRecord::Base.connection.table_exists? 'projects'
      drop_table :projects
    end
    if ActiveRecord::Base.connection.table_exists? 'test_answers'
      drop_table :test_answers
    end
    if ActiveRecord::Base.connection.table_exists? 'test_attempts'
      drop_table :test_attempts
    end
    if ActiveRecord::Base.connection.table_exists? 'test_question_attempts'
      drop_table :test_question_attempts
    end
    if ActiveRecord::Base.connection.table_exists? 'test_questions'
      drop_table :test_questions
    end
    if ActiveRecord::Base.connection.table_exists? 'tests'
      drop_table :tests
    end
  end
end
