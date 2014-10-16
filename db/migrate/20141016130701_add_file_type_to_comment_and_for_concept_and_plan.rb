class AddFileTypeToCommentAndForConceptAndPlan < ActiveRecord::Migration
  def change
    add_column :life_tape_comments, :isFile, :boolean

    add_column :discontent_comments, :image, :string
    add_column :discontent_comments, :isFile, :boolean

    add_column :concept_comments, :image, :string
    add_column :concept_comments, :isFile, :boolean

    add_column :plan_comments, :image, :string
    add_column :plan_comments, :isFile, :boolean

    add_column :estimate_comments, :image, :string
    add_column :estimate_comments, :isFile, :boolean

    add_column :essay_comments, :image, :string
    add_column :essay_comments, :isFile, :boolean

  end
end
