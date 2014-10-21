class RenamePostAdviceToAdvice < ActiveRecord::Migration
  def change
    rename_table :discontent_post_advices, :advices
  end
end
