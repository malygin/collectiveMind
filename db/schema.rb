# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140312152231) do

  create_table "answers", :force => true do |t|
    t.string   "text"
    t.integer  "raiting",     :default => 0
    t.integer  "user_id"
    t.integer  "question_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "answers", ["created_at"], :name => "index_answers_on_created_at"
  add_index "answers", ["user_id"], :name => "index_answers_on_user_id"

  create_table "answers_users", :id => false, :force => true do |t|
    t.integer "answer_id"
    t.integer "user_id"
  end

  add_index "answers_users", ["answer_id"], :name => "index_answers_users_on_answer_id"
  add_index "answers_users", ["user_id"], :name => "index_answers_users_on_user_id"

  create_table "awards", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.text     "desc"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "comments", :force => true do |t|
    t.string   "commenter"
    t.text     "body"
    t.integer  "post_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "comments", ["post_id"], :name => "index_comments_on_post_id"

  create_table "concept_comment_votings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.boolean  "against",    :default => true
  end

  add_index "concept_comment_votings", ["created_at", "comment_id"], :name => "index_concept_comment_voitings_on_created_at_and_comment_id"

  create_table "concept_comments", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "post_id"
    t.boolean  "useful"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "censored",   :default => false
  end

  add_index "concept_comments", ["created_at"], :name => "index_concept_comments_on_created_at"
  add_index "concept_comments", ["post_id"], :name => "index_concept_comments_on_post_id"
  add_index "concept_comments", ["user_id"], :name => "index_concept_comments_on_user_id"

  create_table "concept_post_aspect_discontents", :force => true do |t|
    t.integer  "post_aspect_id"
    t.string   "name"
    t.text     "content"
    t.integer  "discontent_post_id"
    t.text     "positive"
    t.text     "negative"
    t.text     "control"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "concept_post_aspects", :force => true do |t|
    t.integer  "discontent_aspect_id"
    t.integer  "concept_post_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.text     "positive"
    t.text     "negative"
    t.text     "control"
    t.string   "name"
    t.string   "content"
    t.text     "reality"
    t.text     "problems"
    t.text     "positive_r"
    t.text     "negative_r"
  end

  create_table "concept_post_notes", :force => true do |t|
    t.integer  "post_id"
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "concept_post_notes", ["post_id"], :name => "index_concept_post_notes_on_post_id"

  create_table "concept_post_votings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.boolean  "against"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "concept_post_votings", ["post_id", "user_id"], :name => "index_concept_post_voitings_on_post_id_and_user_id"
  add_index "concept_post_votings", ["post_id"], :name => "index_concept_post_voitings_on_post_id"
  add_index "concept_post_votings", ["user_id"], :name => "index_concept_post_voitings_on_user_id"

  create_table "concept_posts", :force => true do |t|
    t.text     "goal"
    t.text     "reality"
    t.integer  "user_id"
    t.integer  "number_views"
    t.integer  "life_tape_post_id"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.integer  "status"
    t.integer  "project_id"
    t.text     "content"
    t.boolean  "censored",          :default => false
  end

  add_index "concept_posts", ["created_at"], :name => "index_concept_posts_on_created_at"
  add_index "concept_posts", ["life_tape_post_id"], :name => "index_concept_posts_on_life_tape_post_id"
  add_index "concept_posts", ["project_id"], :name => "index_concept_posts_on_project_id"
  add_index "concept_posts", ["status"], :name => "index_concept_posts_on_status"
  add_index "concept_posts", ["user_id"], :name => "index_concept_posts_on_user_id"

  create_table "concept_task_supply_pairs", :force => true do |t|
    t.text     "task"
    t.text     "supply"
    t.integer  "post_id"
    t.integer  "order"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "concept_task_supply_pairs", ["post_id"], :name => "index_concept_task_supply_pairs_on_post_id"

  create_table "concept_votings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "concept_post_aspect_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  add_index "concept_votings", ["concept_post_aspect_id"], :name => "index_concept_votings_on_concept_post_id"
  add_index "concept_votings", ["user_id"], :name => "index_concept_votings_on_user_id"

  create_table "core_project_users", :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.integer  "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "core_project_users", ["project_id"], :name => "index_core_project_users_on_project_id"
  add_index "core_project_users", ["user_id"], :name => "index_core_project_users_on_user_id"

  create_table "core_projects", :force => true do |t|
    t.string   "name",         :limit => 500
    t.text     "desc"
    t.text     "short_desc"
    t.integer  "status"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "url_logo"
    t.integer  "type_access"
    t.integer  "stage1",                      :default => 5
    t.integer  "stage2",                      :default => 5
    t.integer  "stage3",                      :default => 5
    t.integer  "stage4",                      :default => 5
    t.integer  "stage5",                      :default => 5
    t.text     "knowledge"
    t.integer  "type_project",                :default => 0
    t.integer  "position",                    :default => 0
    t.string   "secret"
    t.string   "secret2"
    t.string   "secret3"
  end

  add_index "core_projects", ["status"], :name => "index_core_projects_on_status"

  create_table "discontent_aspect_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "aspect_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "discontent_aspect_users", ["user_id"], :name => "index_discontent_aspect_users_on_user_id"

  create_table "discontent_aspects", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "position"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "project_id"
    t.text     "short_desc"
    t.integer  "status",     :default => 0
    t.boolean  "user_add"
  end

  add_index "discontent_aspects", ["project_id"], :name => "index_discontent_aspects_on_project_id"

  create_table "discontent_aspects_life_tape_posts", :force => true do |t|
    t.integer "discontent_aspect_id"
    t.integer "life_tape_post_id"
  end

  add_index "discontent_aspects_life_tape_posts", ["discontent_aspect_id", "life_tape_post_id"], :name => "index_discontent_aspects_life_tape_posts"

  create_table "discontent_comment_votings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.boolean  "against",    :default => true
  end

  add_index "discontent_comment_votings", ["comment_id"], :name => "index_discontent_comment_voitings_on_comment_id"

  create_table "discontent_comments", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "censored",   :default => false
  end

  create_table "discontent_post_notes", :force => true do |t|
    t.integer  "post_id"
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "discontent_post_notes", ["post_id"], :name => "index_discontent_post_notes_on_post_id"

  create_table "discontent_post_replaces", :force => true do |t|
    t.integer  "post_id"
    t.integer  "replace_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "discontent_post_replaces", ["post_id"], :name => "index_discontent_post_replaces_on_post_id"
  add_index "discontent_post_replaces", ["replace_id"], :name => "index_discontent_post_replaces_on_replace_id"

  create_table "discontent_post_votings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.boolean  "against",    :default => true
  end

  add_index "discontent_post_votings", ["post_id", "user_id"], :name => "index_discontent_post_voitings_on_post_id_and_user_id"
  add_index "discontent_post_votings", ["post_id"], :name => "index_discontent_post_voitings_on_post_id"
  add_index "discontent_post_votings", ["user_id"], :name => "index_discontent_post_voitings_on_user_id"

  create_table "discontent_posts", :force => true do |t|
    t.text     "content"
    t.text     "whend"
    t.text     "whered"
    t.integer  "user_id"
    t.integer  "status",             :default => 0
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.integer  "number_views",       :default => 0
    t.integer  "project_id"
    t.integer  "aspect_id"
    t.integer  "replace_id"
    t.integer  "style"
    t.boolean  "censored",           :default => false
    t.integer  "discontent_post_id"
  end

  add_index "discontent_posts", ["aspect_id"], :name => "index_discontent_posts_on_aspect_id"
  add_index "discontent_posts", ["project_id"], :name => "index_discontent_posts_on_project_id"

  create_table "discontent_votings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "discontent_post_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "discontent_votings", ["discontent_post_id"], :name => "index_discontent_votings_on_discontent_post_id"
  add_index "discontent_votings", ["user_id"], :name => "index_discontent_votings_on_user_id"

  create_table "essay_comment_votings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "essay_comment_votings", ["comment_id"], :name => "index_essay_comment_voitings_on_comment_id"

  create_table "essay_comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.text     "content"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "censored",   :default => false
  end

  add_index "essay_comments", ["post_id"], :name => "index_essay_comments_on_post_id"

  create_table "essay_post_votings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "essay_post_votings", ["post_id"], :name => "index_essay_post_voitings_on_post_id"

  create_table "essay_posts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.text     "content"
    t.integer  "status"
    t.integer  "stage"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "number_views", :default => 0
    t.boolean  "censored",     :default => false
  end

  create_table "estimate_comment_votings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.boolean  "against",    :default => true
  end

  add_index "estimate_comment_votings", ["comment_id"], :name => "index_estimate_comment_voitings_on_comment_id"

  create_table "estimate_comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.text     "content"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "censored",   :default => false
  end

  add_index "estimate_comments", ["post_id"], :name => "index_estimate_comments_on_post_id"

  create_table "estimate_final_voitings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.integer  "score"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "estimate_final_voitings", ["user_id"], :name => "index_estimate_final_voitings_on_user_id"

  create_table "estimate_forecasts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "best_student_post_id"
    t.integer  "best_jury_post_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "estimate_forecasts", ["user_id"], :name => "index_estimate_forecasts_on_user_id"

  create_table "estimate_post_aspects", :force => true do |t|
    t.integer  "post_id"
    t.integer  "plan_post_aspect_id"
    t.integer  "op1"
    t.integer  "op2"
    t.integer  "op3"
    t.text     "op"
    t.integer  "ozf1"
    t.integer  "ozf2"
    t.integer  "ozf3"
    t.text     "ozf"
    t.integer  "ozs1"
    t.integer  "ozs2"
    t.integer  "ozs3"
    t.text     "ozs"
    t.integer  "on1"
    t.integer  "on2"
    t.integer  "on3"
    t.text     "on"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.integer  "imp"
    t.integer  "op4"
    t.integer  "ozf4"
    t.integer  "ozs4"
    t.integer  "on4"
    t.integer  "nep1"
    t.integer  "nep2"
    t.integer  "nep3"
    t.integer  "nep4"
    t.text     "nep"
    t.integer  "all_grade"
    t.boolean  "first_stage"
    t.integer  "plan_post_first_cond_id"
  end

  create_table "estimate_post_notes", :force => true do |t|
    t.integer  "post_id"
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "estimate_post_votings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.boolean  "against"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "estimate_post_votings", ["post_id", "user_id"], :name => "index_estimate_post_votings_on_post_id_and_user_id"
  add_index "estimate_post_votings", ["post_id"], :name => "index_estimate_post_votings_on_post_id"
  add_index "estimate_post_votings", ["user_id"], :name => "index_estimate_post_votings_on_user_id"

  create_table "estimate_posts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.text     "content"
    t.integer  "oppsh1"
    t.integer  "oppsh2"
    t.integer  "oppsh3"
    t.text     "oppsh"
    t.integer  "ozpshf1"
    t.integer  "ozpshf2"
    t.integer  "ozpshf3"
    t.text     "ozpshf"
    t.integer  "ozpshs1"
    t.integer  "ozpshs2"
    t.integer  "ozpshs3"
    t.text     "ozpshs"
    t.integer  "onpsh1"
    t.integer  "onpsh2"
    t.integer  "onpsh3"
    t.text     "onpsh"
    t.integer  "nepr1"
    t.integer  "nepr2"
    t.integer  "nepr3"
    t.integer  "nepr4"
    t.text     "nepr"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "status"
    t.integer  "project_id"
    t.integer  "imp"
    t.integer  "nep1"
    t.integer  "nep2"
    t.integer  "nep3"
    t.integer  "nep4"
    t.text     "nep"
    t.integer  "all_grade"
    t.integer  "number_views", :default => 0
    t.boolean  "censored",     :default => false
  end

  add_index "estimate_posts", ["created_at"], :name => "index_estimate_posts_on_created_at"
  add_index "estimate_posts", ["post_id"], :name => "index_estimate_posts_on_post_id"
  add_index "estimate_posts", ["project_id"], :name => "index_estimate_posts_on_project_id"
  add_index "estimate_posts", ["status"], :name => "index_estimate_posts_on_status"
  add_index "estimate_posts", ["user_id"], :name => "index_estimate_posts_on_user_id"

  create_table "estimate_task_triplets", :force => true do |t|
    t.integer  "post_id"
    t.integer  "task_triplet_id"
    t.integer  "op1"
    t.integer  "op2"
    t.integer  "op3"
    t.text     "op"
    t.integer  "ozf1"
    t.integer  "ozf2"
    t.integer  "ozf3"
    t.text     "ozf"
    t.integer  "ozs1"
    t.integer  "ozs2"
    t.integer  "ozs3"
    t.text     "ozs"
    t.integer  "on1"
    t.integer  "on2"
    t.integer  "on3"
    t.text     "on"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "estimate_task_triplets", ["post_id"], :name => "index_estimate_task_triplets_on_post_id"

  create_table "estimate_votings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "estimate_post_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "estimate_votings", ["estimate_post_id"], :name => "index_estimate_votings_on_estimate_post_id"
  add_index "estimate_votings", ["user_id"], :name => "index_estimate_votings_on_user_id"

  create_table "expert_news_comment_votings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "expert_news_comment_votings", ["comment_id"], :name => "index_expert_news_comment_voitings_on_comment_id"

  create_table "expert_news_comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.text     "content"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "censored",   :default => false
  end

  add_index "expert_news_comments", ["post_id"], :name => "index_expert_news_comments_on_post_id"

  create_table "expert_news_post_votings", :force => true do |t|
    t.integer  "post_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "expert_news_post_votings", ["post_id"], :name => "index_expert_news_post_votings_on_post_id"

  create_table "expert_news_posts", :force => true do |t|
    t.string   "title"
    t.text     "anons"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "project_id"
    t.integer  "number_views", :default => 0
    t.boolean  "censored",     :default => false
  end

  add_index "expert_news_posts", ["created_at"], :name => "index_expert_news_posts_on_created_at"
  add_index "expert_news_posts", ["project_id"], :name => "index_expert_news_posts_on_project_id"

  create_table "frustration_comments", :force => true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.integer  "frustration_id"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "negative",               :default => true
    t.string   "comment_admin"
    t.boolean  "trash",                  :default => false
    t.integer  "frustration_comment_id"
  end

  add_index "frustration_comments", ["created_at"], :name => "index_frustration_comments_on_created_at"
  add_index "frustration_comments", ["frustration_id"], :name => "index_frustration_comments_on_frustration_id"
  add_index "frustration_comments", ["user_id"], :name => "index_frustration_comments_on_user_id"

  create_table "frustration_essays", :force => true do |t|
    t.integer  "user_id"
    t.string   "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "frustration_essays", ["user_id"], :name => "index_frustration_essays_on_user_id"

  create_table "frustration_forecasts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "frustration_id"
    t.integer  "order"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "frustration_forecasts", ["frustration_id"], :name => "index_frustration_forecasts_on_frustration_id"
  add_index "frustration_forecasts", ["user_id"], :name => "index_frustration_forecasts_on_user_id"

  create_table "frustrations", :force => true do |t|
    t.string   "what"
    t.string   "wherin"
    t.string   "when"
    t.string   "what_old"
    t.string   "wherin_old"
    t.string   "when_old"
    t.integer  "user_id"
    t.integer  "status",           :default => 0
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "old_content"
    t.integer  "negative_user_id"
    t.integer  "struct_user_id"
    t.datetime "structuring_date"
    t.string   "comment_admin"
    t.boolean  "trash",            :default => false
    t.string   "content_text"
    t.string   "content_text_old"
    t.integer  "project_id",       :default => 1
    t.string   "what_expert"
    t.string   "wherin_expert"
    t.string   "when_expert"
  end

  add_index "frustrations", ["created_at"], :name => "index_frustrations_on_created_at"
  add_index "frustrations", ["status"], :name => "index_frustrations_on_status"
  add_index "frustrations", ["user_id"], :name => "index_frustrations_on_user_id"

  create_table "help_answers", :force => true do |t|
    t.text     "content"
    t.integer  "question_id"
    t.integer  "order"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "help_posts", :force => true do |t|
    t.text     "content"
    t.integer  "stage"
    t.boolean  "mini"
    t.integer  "style"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "title"
  end

  create_table "help_questions", :force => true do |t|
    t.text     "content"
    t.integer  "post_id"
    t.integer  "order"
    t.integer  "style"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "help_users_answers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "answer_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "journals", :force => true do |t|
    t.integer  "user_id"
    t.string   "type_event"
    t.string   "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "project_id"
  end

  add_index "journals", ["created_at"], :name => "index_journals_on_created_at"
  add_index "journals", ["project_id"], :name => "index_journals_on_project_id"
  add_index "journals", ["type_event"], :name => "index_journals_on_type"
  add_index "journals", ["user_id"], :name => "index_journals_on_user_id"

  create_table "knowbase_posts", :force => true do |t|
    t.text     "content"
    t.integer  "project_id"
    t.integer  "stage"
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "life_tape_categories", :force => true do |t|
    t.string   "name"
    t.text     "short_desc"
    t.text     "long_desc"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "life_tape_comment_votings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.boolean  "against",    :default => true
  end

  add_index "life_tape_comment_votings", ["user_id", "comment_id"], :name => "index_life_tape_comment_voitings_on_user_id_and_comment_id"

  create_table "life_tape_comments", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "censored",   :default => false
  end

  add_index "life_tape_comments", ["created_at"], :name => "index_life_tape_comments_on_created_at"
  add_index "life_tape_comments", ["post_id"], :name => "index_life_tape_comments_on_post_id"
  add_index "life_tape_comments", ["user_id"], :name => "index_life_tape_comments_on_user_id"

  create_table "life_tape_post_votings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.boolean  "against",    :default => true
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "life_tape_post_votings", ["post_id", "user_id"], :name => "index_life_tape_post_voitings_on_post_id_and_user_id"
  add_index "life_tape_post_votings", ["post_id"], :name => "index_life_tape_post_voitings_on_post_id"
  add_index "life_tape_post_votings", ["user_id"], :name => "index_life_tape_post_voitings_on_user_id"

  create_table "life_tape_posts", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "post_id"
    t.integer  "category_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "number_views", :default => 0
    t.integer  "project_id"
    t.boolean  "important",    :default => false
    t.integer  "aspect_id"
    t.boolean  "censored",     :default => false
    t.integer  "status",       :default => 0
  end

  add_index "life_tape_posts", ["category_id"], :name => "index_life_tape_posts_on_category_id"
  add_index "life_tape_posts", ["created_at"], :name => "index_life_tape_posts_on_created_at"
  add_index "life_tape_posts", ["post_id"], :name => "index_life_tape_posts_on_post_id"
  add_index "life_tape_posts", ["project_id"], :name => "index_life_tape_posts_on_project_id"
  add_index "life_tape_posts", ["user_id"], :name => "index_life_tape_posts_on_user_id"

  create_table "life_tape_voitings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "discontent_aspect_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "life_tape_voitings", ["discontent_aspect_id"], :name => "index_life_tape_voitings_on_discontent_aspect_id"
  add_index "life_tape_voitings", ["user_id"], :name => "index_life_tape_voitings_on_user_id"

  create_table "plan_comment_votings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.boolean  "against",    :default => true
  end

  add_index "plan_comment_votings", ["comment_id"], :name => "index_plan_comment_voitings_on_comment_id"

  create_table "plan_comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.text     "content"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "censored",   :default => false
  end

  add_index "plan_comments", ["post_id"], :name => "index_plan_comments_on_post_id"

  create_table "plan_post_aspects", :force => true do |t|
    t.integer  "discontent_aspect_id"
    t.integer  "plan_post_id"
    t.text     "positive"
    t.text     "negative"
    t.text     "control"
    t.text     "problems"
    t.text     "reality"
    t.integer  "first_stage"
    t.string   "name"
    t.string   "content"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.integer  "concept_post_aspect_id"
  end

  create_table "plan_post_first_conds", :force => true do |t|
    t.integer  "plan_post_id"
    t.integer  "post_aspect_id"
    t.text     "positive"
    t.text     "negative"
    t.text     "control"
    t.text     "problems"
    t.text     "problems_with_resources"
    t.text     "reality"
    t.string   "name"
    t.string   "content"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "plan_post_notes", :force => true do |t|
    t.integer  "post_id"
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "plan_post_votings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.boolean  "against",    :default => true
  end

  add_index "plan_post_votings", ["post_id"], :name => "index_plan_post_voitings_on_post_id"

  create_table "plan_posts", :force => true do |t|
    t.integer  "user_id"
    t.text     "goal"
    t.text     "first_step"
    t.text     "other_steps"
    t.integer  "status"
    t.integer  "number_views"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "project_id"
    t.text     "content"
    t.integer  "step",         :default => 1
    t.boolean  "censored",     :default => false
    t.text     "plan_first"
    t.text     "plan_other"
    t.text     "plan_control"
  end

  add_index "plan_posts", ["created_at"], :name => "index_plan_posts_on_created_at"
  add_index "plan_posts", ["project_id"], :name => "index_plan_posts_on_project_id"
  add_index "plan_posts", ["user_id"], :name => "index_plan_posts_on_user_id"

  create_table "plan_task_triplets", :force => true do |t|
    t.integer  "post_id"
    t.integer  "position"
    t.boolean  "compulsory"
    t.text     "task"
    t.text     "supply"
    t.text     "howto"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "plan_task_triplets", ["post_id"], :name => "index_plan_task_triplets_on_post_id"

  create_table "plan_votings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "plan_post_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "text"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "question_comment_votings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "question_comment_votings", ["comment_id"], :name => "index_question_comment_votings_on_comment_id"

  create_table "question_comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.text     "content"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "censored",   :default => false
  end

  add_index "question_comments", ["post_id"], :name => "index_question_comments_on_post_id"

  create_table "question_post_votings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "question_post_votings", ["post_id"], :name => "index_question_post_votings_on_post_id"

  create_table "question_posts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.text     "content"
    t.integer  "status"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "number_views", :default => 0
    t.boolean  "censored",     :default => false
  end

  add_index "question_posts", ["project_id"], :name => "index_questions_posts_on_project_id"

  create_table "questions", :force => true do |t|
    t.string   "text"
    t.integer  "raiting",    :default => 0
    t.integer  "user_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "questions", ["created_at"], :name => "index_questions_on_created_at"
  add_index "questions", ["user_id"], :name => "index_questions_on_user_id"

  create_table "questions_users", :id => false, :force => true do |t|
    t.integer "question_id"
    t.integer "user_id"
  end

  add_index "questions_users", ["question_id"], :name => "index_questions_users_on_question_id"
  add_index "questions_users", ["user_id"], :name => "index_questions_users_on_user_id"

  create_table "user_awards", :force => true do |t|
    t.integer  "user_id"
    t.integer  "award_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "project_id"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "surname"
    t.string   "email"
    t.string   "group"
    t.string   "string"
    t.string   "faculty"
    t.boolean  "validate"
    t.date     "dateRegistration"
    t.date     "dateActivation"
    t.date     "dateLastEnter"
    t.string   "vkid"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "encrypted_password"
    t.string   "login"
    t.string   "salt"
    t.boolean  "admin",                  :default => false
    t.integer  "score",                  :default => 0
    t.boolean  "expert",                 :default => false
    t.string   "user_type"
    t.boolean  "jury",                   :default => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "nickname"
    t.boolean  "anonym",                 :default => false
    t.integer  "score_a",                :default => 0
    t.integer  "score_g",                :default => 0
    t.integer  "score_o",                :default => 0
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,     :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "voitings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "frustration_id"
    t.integer  "score"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

end
