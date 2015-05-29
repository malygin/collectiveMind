class AddAnswerIdToCoreAspectComment < ActiveRecord::Migration
  def change
    add_column :core_aspect_comments, :answer_id, :integer
  end
end
