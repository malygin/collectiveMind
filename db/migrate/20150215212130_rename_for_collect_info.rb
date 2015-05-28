class RenameForCollectInfo < ActiveRecord::Migration
  def change
    remove_column :core_aspects, :user_add

    rename_column :collect_info_votings, :discontent_aspect_id, :aspect_id
    #execute "ALTER TABLE collect_info_votings DROP CONSTRAINT life_tape_voitings_pkey;"
    #execute "ALTER TABLE collect_info_votings ADD PRIMARY KEY (id);"

    remove_column :collect_info_questions, :raiting
    remove_column :collect_info_questions, :post_id
    remove_column :collect_info_questions, :parent_post_type
    add_column :collect_info_questions, :aspect_id, :integer
    #execute "ALTER TABLE collect_info_questions DROP CONSTRAINT questions_pkey;"
    #execute "ALTER TABLE collect_info_questions ADD PRIMARY KEY (id);"


    remove_column :collect_info_answers, :raiting
    remove_column :collect_info_answers, :style
    add_column :collect_info_answers, :correct, :boolean

    #execute "ALTER TABLE collect_info_answers DROP CONSTRAINT answers_pkey;"
    #execute "ALTER TABLE collect_info_answers ADD PRIMARY KEY (id);"

    drop_table :collect_info_answers_users

    create_table :collect_info_user_answers do |t|
      t.references :user, index: true
      t.references :answer, index: true
      t.references :question, index: true
      t.references :aspect, index: true
      t.references :project, index: true

      t.timestamps
    end
  end
end
