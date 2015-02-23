class MoveConceptPostAspectFields < ActiveRecord::Migration
  def up
    drop_table :concept_post_aspects
    change_table :concept_posts do |t|
      t.references :core_aspect
      t.text 'positive'
      t.text 'negative'
      t.text 'control'
      t.text 'name'
      t.text 'problems'
      t.text 'positive_r'
      t.text 'negative_r'
      t.text 'title'
      t.text 'obstacles'
    end
  end

  def down
    create_table 'concept_post_aspects' do |t|
      t.integer 'core_aspect_id'
      t.integer 'concept_post_id'
      t.datetime 'created_at'
      t.datetime 'updated_at'
      t.text 'positive'
      t.text 'negative'
      t.text 'control'
      t.text 'name'
      t.text 'content'
      t.text 'reality'
      t.text 'problems'
      t.text 'positive_r'
      t.text 'negative_r'
      t.text 'title'
      t.text 'obstacles'
    end

    change_table :concept_posts do |t|
      t.remove :core_aspect_id
      t.remove 'positive'
      t.remove 'negative'
      t.remove 'control'
      t.remove 'name'
      t.remove 'problems'
      t.remove 'positive_r'
      t.remove 'negative_r'
      t.remove 'title'
      t.remove 'obstacles'
    end
  end
end
