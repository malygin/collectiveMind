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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150215184933) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "advice_comments", force: true do |t|
    t.integer  "post_advice_id"
    t.integer  "user_id"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "advice_comments", ["post_advice_id"], name: "index_advice_comments_on_post_advice_id", using: :btree
  add_index "advice_comments", ["user_id"], name: "index_advice_comments_on_user_id", using: :btree

  create_table "advices", force: true do |t|
    t.text     "content"
    t.boolean  "approved"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "adviseable_id",   null: false
    t.string   "adviseable_type", null: false
    t.boolean  "useful"
    t.integer  "project_id",      null: false
  end

  add_index "advices", ["user_id"], name: "index_advices_on_user_id", using: :btree

  create_table "awards", force: true do |t|
    t.string  "name"
    t.string  "url"
    t.text    "desc"
    t.integer "position"
  end

  create_table "collect_info_answers", force: true do |t|
    t.text     "content"
    t.integer  "raiting",     default: 0
    t.integer  "user_id"
    t.integer  "question_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "style"
    t.integer  "status"
  end

  add_index "collect_info_answers", ["created_at"], name: "index_collect_info_answers_on_created_at", using: :btree
  add_index "collect_info_answers", ["user_id"], name: "index_collect_info_answers_on_user_id", using: :btree

  create_table "collect_info_answers_users", id: false, force: true do |t|
    t.integer  "answer_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
    t.integer  "question_id"
  end

  add_index "collect_info_answers_users", ["answer_id"], name: "index_collect_info_answers_users_on_answer_id", using: :btree
  add_index "collect_info_answers_users", ["user_id"], name: "index_collect_info_answers_users_on_user_id", using: :btree

  create_table "collect_info_questions", force: true do |t|
    t.text     "content"
    t.integer  "raiting",          default: 0
    t.integer  "user_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "project_id"
    t.integer  "status"
    t.integer  "post_id"
    t.string   "parent_post_type"
    t.text     "hint"
  end

  add_index "collect_info_questions", ["created_at"], name: "index_collect_info_questions_on_created_at", using: :btree
  add_index "collect_info_questions", ["user_id"], name: "index_collect_info_questions_on_user_id", using: :btree

  create_table "collect_info_votings", force: true do |t|
    t.integer  "user_id"
    t.integer  "discontent_aspect_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "collect_info_votings", ["discontent_aspect_id"], name: "index_collect_info_votings_on_discontent_aspect_id", using: :btree
  add_index "collect_info_votings", ["user_id"], name: "index_collect_info_votings_on_user_id", using: :btree

  create_table "comments", force: true do |t|
    t.string   "commenter"
    t.text     "body"
    t.integer  "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "comments", ["post_id"], name: "index_comments_on_post_id", using: :btree

  create_table "concept_comment_votings", force: true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "against",    default: true
  end

  add_index "concept_comment_votings", ["created_at", "comment_id"], name: "index_concept_comment_voitings_on_created_at_and_comment_id", using: :btree

  create_table "concept_comments", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "post_id"
    t.boolean  "useful"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.boolean  "censored",          default: false
    t.integer  "comment_id"
    t.boolean  "discontent_status"
    t.boolean  "concept_status"
    t.boolean  "discuss_status"
    t.boolean  "approve_status"
    t.string   "image"
    t.boolean  "isFile"
  end

  add_index "concept_comments", ["created_at"], name: "index_concept_comments_on_created_at", using: :btree
  add_index "concept_comments", ["post_id"], name: "index_concept_comments_on_post_id", using: :btree
  add_index "concept_comments", ["user_id"], name: "index_concept_comments_on_user_id", using: :btree

  create_table "concept_essays", force: true do |t|
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "concept_final_voitings", force: true do |t|
    t.integer  "score"
    t.integer  "forecast_task_id"
    t.integer  "user_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "concept_final_voitings", ["forecast_task_id"], name: "index_concept_final_voitings_on_forecast_task_id", using: :btree
  add_index "concept_final_voitings", ["user_id"], name: "index_concept_final_voitings_on_user_id", using: :btree

  create_table "concept_forecast_tasks", force: true do |t|
    t.integer  "user_id"
    t.text     "content"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "concept_forecasts", force: true do |t|
    t.integer  "forecast_task_id"
    t.integer  "position"
    t.integer  "user_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "concept_forecasts", ["forecast_task_id"], name: "index_concept_forecasts_on_forecast_task_id", using: :btree
  add_index "concept_forecasts", ["user_id"], name: "index_concept_forecasts_on_user_id", using: :btree

  create_table "concept_notes", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "post_id"
    t.integer  "type_field"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "concept_post_aspect_discontents", force: true do |t|
    t.integer  "post_aspect_id"
    t.string   "name",               limit: 1000
    t.text     "content"
    t.integer  "discontent_post_id"
    t.text     "positive"
    t.text     "negative"
    t.text     "control"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "concept_post_aspects", force: true do |t|
    t.integer  "discontent_aspect_id"
    t.integer  "concept_post_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.text     "positive"
    t.text     "negative"
    t.text     "control"
    t.text     "name"
    t.text     "content"
    t.text     "reality"
    t.text     "problems"
    t.text     "positive_r"
    t.text     "negative_r"
    t.text     "title"
    t.text     "obstacles"
  end

  create_table "concept_post_discontent_complites", force: true do |t|
    t.integer  "post_id"
    t.integer  "discontent_post_id"
    t.integer  "complite"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "concept_post_discontents", force: true do |t|
    t.integer  "post_id"
    t.integer  "discontent_post_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "complite"
    t.integer  "status"
  end

  create_table "concept_post_discussions", force: true do |t|
    t.integer  "user_id"
    t.integer  "discontent_post_id"
    t.integer  "post_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "concept_post_means", force: true do |t|
    t.string   "name"
    t.text     "desc"
    t.integer  "post_id"
    t.integer  "resource_id"
    t.string   "type_res"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "concept_post_notes", force: true do |t|
    t.integer  "post_id"
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "concept_post_notes", ["post_id"], name: "index_concept_post_notes_on_post_id", using: :btree

  create_table "concept_post_resources", force: true do |t|
    t.string   "name"
    t.text     "desc"
    t.integer  "post_id"
    t.integer  "resource_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "project_id"
    t.string   "type_res"
    t.integer  "concept_post_resource_id"
    t.integer  "style"
  end

  create_table "concept_post_votings", force: true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.boolean  "against"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "concept_post_votings", ["post_id", "user_id"], name: "index_concept_post_voitings_on_post_id_and_user_id", using: :btree
  add_index "concept_post_votings", ["post_id"], name: "index_concept_post_voitings_on_post_id", using: :btree
  add_index "concept_post_votings", ["user_id"], name: "index_concept_post_voitings_on_user_id", using: :btree

  create_table "concept_posts", force: true do |t|
    t.text     "goal"
    t.text     "reality"
    t.integer  "user_id"
    t.integer  "number_views"
    t.integer  "life_tape_post_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "status"
    t.integer  "project_id"
    t.text     "content"
    t.boolean  "censored",          default: false
    t.boolean  "status_name"
    t.boolean  "status_content"
    t.boolean  "status_positive"
    t.boolean  "status_positive_r"
    t.boolean  "status_negative"
    t.boolean  "status_negative_r"
    t.boolean  "status_problems"
    t.boolean  "status_reality"
    t.integer  "improve_comment"
    t.integer  "improve_stage"
    t.boolean  "discuss_status"
    t.boolean  "useful"
    t.boolean  "status_positive_s"
    t.boolean  "status_negative_s"
    t.boolean  "status_control"
    t.boolean  "status_control_r"
    t.boolean  "status_control_s"
    t.boolean  "status_obstacles"
    t.boolean  "approve_status"
    t.integer  "fullness"
    t.boolean  "status_all"
  end

  add_index "concept_posts", ["created_at"], name: "index_concept_posts_on_created_at", using: :btree
  add_index "concept_posts", ["life_tape_post_id"], name: "index_concept_posts_on_life_tape_post_id", using: :btree
  add_index "concept_posts", ["project_id", "status"], name: "index_concept_posts_on_project_id_and_status", using: :btree
  add_index "concept_posts", ["project_id"], name: "index_concept_posts_on_project_id", using: :btree
  add_index "concept_posts", ["status"], name: "index_concept_posts_on_status", using: :btree
  add_index "concept_posts", ["user_id"], name: "index_concept_posts_on_user_id", using: :btree

  create_table "concept_resources", force: true do |t|
    t.string  "name"
    t.text    "desc"
    t.integer "project_id"
  end

  create_table "concept_task_supply_pairs", force: true do |t|
    t.text     "task"
    t.text     "supply"
    t.integer  "post_id"
    t.integer  "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "concept_task_supply_pairs", ["post_id"], name: "index_concept_task_supply_pairs_on_post_id", using: :btree

  create_table "concept_votings", force: true do |t|
    t.integer  "user_id"
    t.integer  "concept_post_aspect_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "discontent_post_id"
  end

  add_index "concept_votings", ["concept_post_aspect_id"], name: "index_concept_votings_on_concept_post_id", using: :btree
  add_index "concept_votings", ["user_id"], name: "index_concept_votings_on_user_id", using: :btree

  create_table "core_aspects", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "position"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "project_id"
    t.text     "short_desc"
    t.integer  "status",         default: 0
    t.boolean  "user_add"
    t.integer  "core_aspect_id"
    t.string   "color"
    t.string   "short_name"
  end

  add_index "core_aspects", ["project_id"], name: "index_core_aspects_on_project_id", using: :btree

  create_table "core_essay_comments", force: true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.text     "content"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.boolean  "censored",          default: false
    t.integer  "comment_id"
    t.boolean  "discontent_status"
    t.boolean  "concept_status"
    t.boolean  "discuss_status"
    t.boolean  "useful"
    t.boolean  "approve_status"
    t.string   "image"
    t.boolean  "isFile"
  end

  add_index "core_essay_comments", ["post_id"], name: "index_core_essay_comments_on_post_id", using: :btree

  create_table "core_essay_post_votings", force: true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "against"
  end

  add_index "core_essay_post_votings", ["post_id"], name: "index_essay_post_voitings_on_post_id", using: :btree

  create_table "core_essay_posts", force: true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.text     "content"
    t.integer  "status"
    t.integer  "stage"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "number_views",   default: 0
    t.boolean  "censored",       default: false
    t.text     "negative"
    t.text     "positive"
    t.text     "change"
    t.text     "reaction"
    t.boolean  "useful"
    t.boolean  "approve_status"
  end

  create_table "core_help_posts", force: true do |t|
    t.text     "content"
    t.integer  "stage"
    t.boolean  "mini"
    t.integer  "style"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "title"
  end

  create_table "core_knowbase_posts", force: true do |t|
    t.text     "content"
    t.integer  "project_id"
    t.integer  "stage"
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "aspect_id"
  end

  create_table "core_project_scores", force: true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "score",      default: 0
    t.integer  "score_a",    default: 0
    t.integer  "score_g",    default: 0
    t.integer  "score_o",    default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "core_project_settings", force: true do |t|
    t.json     "stage_dates"
    t.integer  "project_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "core_project_settings", ["project_id"], name: "index_core_project_settings_on_project_id", using: :btree

  create_table "core_project_users", force: true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.boolean  "owner",            default: false
    t.integer  "type_user"
    t.boolean  "ready_to_concept", default: false
  end

  add_index "core_project_users", ["project_id"], name: "index_core_project_users_on_project_id", using: :btree
  add_index "core_project_users", ["user_id"], name: "index_core_project_users_on_user_id", using: :btree

  create_table "core_projects", force: true do |t|
    t.string   "name",               limit: 500
    t.text     "desc"
    t.text     "short_desc"
    t.integer  "status",                         default: 1
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "url_logo"
    t.integer  "type_access"
    t.integer  "stage1",                         default: 5
    t.integer  "stage2",                         default: 5
    t.integer  "stage3",                         default: 5
    t.integer  "stage4",                         default: 5
    t.integer  "stage5",                         default: 5
    t.text     "knowledge"
    t.integer  "position",                       default: 0
    t.string   "secret"
    t.string   "secret2"
    t.string   "secret3"
    t.boolean  "advices_discontent"
    t.boolean  "advices_concept"
    t.string   "color"
    t.string   "code"
    t.integer  "moderator_id"
    t.datetime "date_12"
    t.datetime "date_23"
    t.datetime "date_34"
    t.datetime "date_45"
    t.datetime "date_56"
    t.date     "date_start"
    t.date     "date_end"
    t.integer  "count_stages"
  end

  add_index "core_projects", ["status"], name: "index_core_projects_on_status", using: :btree

  create_table "core_user_award_clicks", force: true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "clicks",     default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "core_user_awards", force: true do |t|
    t.integer  "user_id"
    t.integer  "award_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "project_id"
    t.integer  "position"
  end

  create_table "discontent_aspect_users", force: true do |t|
    t.integer  "user_id"
    t.integer  "aspect_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "discontent_aspect_users", ["user_id"], name: "index_discontent_aspect_users_on_user_id", using: :btree

  create_table "discontent_aspects_life_tape_posts", force: true do |t|
    t.integer "discontent_aspect_id"
    t.integer "life_tape_post_id"
  end

  add_index "discontent_aspects_life_tape_posts", ["discontent_aspect_id", "life_tape_post_id"], name: "index_discontent_aspects_life_tape_posts", using: :btree

  create_table "discontent_comment_notes", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "post_id"
    t.integer  "type_field"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "discontent_comment_votings", force: true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "against",    default: true
  end

  add_index "discontent_comment_votings", ["comment_id"], name: "index_discontent_comment_voitings_on_comment_id", using: :btree

  create_table "discontent_comments", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.boolean  "censored",          default: false
    t.integer  "comment_id"
    t.boolean  "discontent_status"
    t.boolean  "concept_status"
    t.boolean  "discuss_status"
    t.boolean  "useful"
    t.boolean  "approve_status"
    t.string   "image"
    t.boolean  "isFile"
  end

  create_table "discontent_notes", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "post_id"
    t.integer  "type_field"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "discontent_post_aspects", force: true do |t|
    t.integer  "post_id"
    t.integer  "aspect_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "discontent_post_discussions", force: true do |t|
    t.integer  "user_id"
    t.integer  "aspect_id"
    t.integer  "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "discontent_post_notes", force: true do |t|
    t.integer  "post_id"
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "discontent_post_notes", ["post_id"], name: "index_discontent_post_notes_on_post_id", using: :btree

  create_table "discontent_post_replaces", force: true do |t|
    t.integer  "post_id"
    t.integer  "replace_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "discontent_post_replaces", ["post_id"], name: "index_discontent_post_replaces_on_post_id", using: :btree
  add_index "discontent_post_replaces", ["replace_id"], name: "index_discontent_post_replaces_on_replace_id", using: :btree

  create_table "discontent_post_votings", force: true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "against",    default: true
  end

  add_index "discontent_post_votings", ["post_id", "user_id"], name: "index_discontent_post_voitings_on_post_id_and_user_id", using: :btree
  add_index "discontent_post_votings", ["post_id"], name: "index_discontent_post_voitings_on_post_id", using: :btree
  add_index "discontent_post_votings", ["user_id"], name: "index_discontent_post_voitings_on_user_id", using: :btree

  create_table "discontent_post_whens", force: true do |t|
    t.string  "content"
    t.integer "project_id"
  end

  create_table "discontent_post_wheres", force: true do |t|
    t.string  "content"
    t.integer "project_id"
  end

  create_table "discontent_posts", force: true do |t|
    t.text     "content"
    t.text     "whend"
    t.text     "whered"
    t.integer  "user_id"
    t.integer  "status",             default: 0
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "number_views",       default: 0
    t.integer  "project_id"
    t.integer  "aspect_id"
    t.integer  "replace_id"
    t.integer  "original_id"
    t.integer  "style"
    t.boolean  "censored",           default: false
    t.integer  "discontent_post_id"
    t.boolean  "important"
    t.boolean  "status_content"
    t.boolean  "status_whered"
    t.boolean  "status_whend"
    t.integer  "improve_comment"
    t.integer  "improve_stage"
    t.boolean  "discuss_status"
    t.boolean  "useful"
    t.boolean  "approve_status"
    t.boolean  "anonym",             default: false
  end

  add_index "discontent_posts", ["aspect_id"], name: "index_discontent_posts_on_aspect_id", using: :btree
  add_index "discontent_posts", ["project_id", "status"], name: "index_discontent_posts_on_project_id_and_status", using: :btree
  add_index "discontent_posts", ["project_id"], name: "index_discontent_posts_on_project_id", using: :btree

  create_table "discontent_votings", force: true do |t|
    t.integer  "user_id"
    t.integer  "discontent_post_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.boolean  "against"
  end

  add_index "discontent_votings", ["discontent_post_id"], name: "index_discontent_votings_on_discontent_post_id", using: :btree
  add_index "discontent_votings", ["user_id"], name: "index_discontent_votings_on_user_id", using: :btree

  create_table "essay_comment_votings", force: true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "against"
  end

  add_index "essay_comment_votings", ["comment_id"], name: "index_essay_comment_voitings_on_comment_id", using: :btree

  create_table "estimate_comment_votings", force: true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "against",    default: true
  end

  add_index "estimate_comment_votings", ["comment_id"], name: "index_estimate_comment_voitings_on_comment_id", using: :btree

  create_table "estimate_comments", force: true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.text     "content"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.boolean  "censored",          default: false
    t.integer  "comment_id"
    t.boolean  "discontent_status"
    t.boolean  "concept_status"
    t.boolean  "discuss_status"
    t.boolean  "useful"
    t.boolean  "approve_status"
    t.string   "image"
    t.boolean  "isFile"
  end

  add_index "estimate_comments", ["post_id"], name: "index_estimate_comments_on_post_id", using: :btree

  create_table "estimate_final_voitings", force: true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.integer  "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "estimate_final_voitings", ["user_id"], name: "index_estimate_final_voitings_on_user_id", using: :btree

  create_table "estimate_forecasts", force: true do |t|
    t.integer  "user_id"
    t.integer  "best_student_post_id"
    t.integer  "best_jury_post_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "estimate_forecasts", ["user_id"], name: "index_estimate_forecasts_on_user_id", using: :btree

  create_table "estimate_post_aspects", force: true do |t|
    t.integer  "post_id"
    t.integer  "plan_post_aspect_id"
    t.float    "op1"
    t.float    "op2"
    t.float    "op3"
    t.text     "op"
    t.float    "ozf1"
    t.float    "ozf2"
    t.float    "ozf3"
    t.text     "ozf"
    t.float    "ozs1"
    t.float    "ozs2"
    t.float    "ozs3"
    t.text     "ozs"
    t.float    "on1"
    t.float    "on2"
    t.float    "on3"
    t.text     "on"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "imp"
    t.float    "op4"
    t.float    "ozf4"
    t.float    "ozs4"
    t.float    "on4"
    t.integer  "nep1"
    t.integer  "nep2"
    t.integer  "nep3"
    t.integer  "nep4"
    t.text     "nep"
    t.integer  "all_grade"
    t.boolean  "first_stage"
    t.integer  "plan_post_first_cond_id"
  end

  create_table "estimate_post_notes", force: true do |t|
    t.integer  "post_id"
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "estimate_post_votings", force: true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.boolean  "against"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "estimate_post_votings", ["post_id", "user_id"], name: "index_estimate_post_votings_on_post_id_and_user_id", using: :btree
  add_index "estimate_post_votings", ["post_id"], name: "index_estimate_post_votings_on_post_id", using: :btree
  add_index "estimate_post_votings", ["user_id"], name: "index_estimate_post_votings_on_user_id", using: :btree

  create_table "estimate_posts", force: true do |t|
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
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "status"
    t.integer  "project_id"
    t.integer  "imp"
    t.integer  "nep1"
    t.integer  "nep2"
    t.integer  "nep3"
    t.integer  "nep4"
    t.text     "nep"
    t.integer  "all_grade"
    t.integer  "number_views",   default: 0
    t.boolean  "censored",       default: false
    t.boolean  "useful"
    t.boolean  "approve_status"
  end

  add_index "estimate_posts", ["created_at"], name: "index_estimate_posts_on_created_at", using: :btree
  add_index "estimate_posts", ["post_id"], name: "index_estimate_posts_on_post_id", using: :btree
  add_index "estimate_posts", ["project_id"], name: "index_estimate_posts_on_project_id", using: :btree
  add_index "estimate_posts", ["status"], name: "index_estimate_posts_on_status", using: :btree
  add_index "estimate_posts", ["user_id"], name: "index_estimate_posts_on_user_id", using: :btree

  create_table "estimate_task_triplets", force: true do |t|
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
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "estimate_task_triplets", ["post_id"], name: "index_estimate_task_triplets_on_post_id", using: :btree

  create_table "estimate_votings", force: true do |t|
    t.integer  "user_id"
    t.integer  "estimate_post_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "estimate_votings", ["estimate_post_id"], name: "index_estimate_votings_on_estimate_post_id", using: :btree
  add_index "estimate_votings", ["user_id"], name: "index_estimate_votings_on_user_id", using: :btree

  create_table "expert_news_comment_votings", force: true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "expert_news_comment_votings", ["comment_id"], name: "index_expert_news_comment_voitings_on_comment_id", using: :btree

  create_table "expert_news_comments", force: true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.text     "content"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "censored",   default: false
  end

  add_index "expert_news_comments", ["post_id"], name: "index_expert_news_comments_on_post_id", using: :btree

  create_table "expert_news_post_votings", force: true do |t|
    t.integer  "post_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "expert_news_post_votings", ["post_id"], name: "index_expert_news_post_votings_on_post_id", using: :btree

  create_table "expert_news_posts", force: true do |t|
    t.string   "title"
    t.text     "anons"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "project_id"
    t.integer  "number_views", default: 0
    t.boolean  "censored",     default: false
  end

  add_index "expert_news_posts", ["created_at"], name: "index_expert_news_posts_on_created_at", using: :btree
  add_index "expert_news_posts", ["project_id"], name: "index_expert_news_posts_on_project_id", using: :btree

  create_table "frustration_comments", force: true do |t|
    t.string   "content",                limit: 500
    t.integer  "user_id"
    t.integer  "frustration_id"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.boolean  "negative",                           default: true
    t.string   "comment_admin"
    t.boolean  "trash",                              default: false
    t.integer  "frustration_comment_id"
    t.integer  "useful_frustration_id"
  end

  add_index "frustration_comments", ["created_at"], name: "index_frustration_comments_on_created_at", using: :btree
  add_index "frustration_comments", ["frustration_id"], name: "index_frustration_comments_on_frustration_id", using: :btree
  add_index "frustration_comments", ["useful_frustration_id"], name: "index_frustration_comments_on_useful_frustration_id", using: :btree
  add_index "frustration_comments", ["user_id"], name: "index_frustration_comments_on_user_id", using: :btree

  create_table "frustration_essays", force: true do |t|
    t.integer  "user_id"
    t.string   "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "frustration_essays", ["user_id"], name: "index_frustration_essays_on_user_id", using: :btree

  create_table "frustration_forecasts", force: true do |t|
    t.integer  "user_id"
    t.integer  "frustration_id"
    t.integer  "order"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "frustration_forecasts", ["frustration_id"], name: "index_frustration_forecasts_on_frustration_id", using: :btree
  add_index "frustration_forecasts", ["user_id"], name: "index_frustration_forecasts_on_user_id", using: :btree

  create_table "frustrations", force: true do |t|
    t.string   "what",             limit: 500
    t.string   "wherin",           limit: 500
    t.string   "when",             limit: 500
    t.string   "what_old",         limit: 500
    t.string   "wherin_old",       limit: 500
    t.string   "when_old"
    t.integer  "user_id"
    t.integer  "status",                       default: 0
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "old_content",      limit: 500
    t.integer  "negative_user_id"
    t.integer  "struct_user_id"
    t.datetime "structuring_date"
    t.string   "comment_admin"
    t.boolean  "trash",                        default: false
    t.string   "content_text",     limit: 500
    t.string   "content_text_old", limit: 500
    t.integer  "project_id",                   default: 1
    t.string   "what_expert",      limit: 500
    t.string   "wherin_expert",    limit: 500
    t.string   "when_expert",      limit: 500
  end

  add_index "frustrations", ["created_at"], name: "index_frustrations_on_created_at", using: :btree
  add_index "frustrations", ["status"], name: "index_frustrations_on_status", using: :btree
  add_index "frustrations", ["user_id"], name: "index_frustrations_on_user_id", using: :btree

  create_table "group_chat_messages", force: true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_chat_messages", ["group_id"], name: "index_group_chat_messages_on_group_id", using: :btree
  add_index "group_chat_messages", ["user_id"], name: "index_group_chat_messages_on_user_id", using: :btree

  create_table "group_task_users", force: true do |t|
    t.integer  "user_id"
    t.integer  "group_task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_task_users", ["group_task_id"], name: "index_group_task_users_on_group_task_id", using: :btree
  add_index "group_task_users", ["user_id"], name: "index_group_task_users_on_user_id", using: :btree

  create_table "group_tasks", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",      default: 10
  end

  add_index "group_tasks", ["group_id"], name: "index_group_tasks_on_group_id", using: :btree

  create_table "group_users", force: true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "owner",             default: false
    t.boolean  "invite_accepted"
    t.datetime "last_seen_chat_at"
  end

  add_index "group_users", ["group_id"], name: "index_group_users_on_group_id", using: :btree
  add_index "group_users", ["user_id"], name: "index_group_users_on_user_id", using: :btree

  create_table "groups", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["project_id"], name: "index_groups_on_project_id", using: :btree

  create_table "help_answers", force: true do |t|
    t.text     "content"
    t.integer  "question_id"
    t.integer  "order"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "help_questions", force: true do |t|
    t.text     "content"
    t.integer  "post_id"
    t.integer  "order"
    t.integer  "style"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "help_users_answers", force: true do |t|
    t.integer  "user_id"
    t.integer  "answer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "journal_mailers", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "status"
    t.boolean  "sent"
    t.boolean  "viewed",     default: false
    t.boolean  "visible",    default: true
    t.integer  "receiver"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "journals", force: true do |t|
    t.integer  "user_id"
    t.string   "type_event"
    t.text     "body"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "project_id"
    t.integer  "user_informed"
    t.boolean  "viewed"
    t.integer  "event"
    t.integer  "first_id"
    t.integer  "second_id"
    t.boolean  "personal",      default: false
    t.string   "body2"
    t.boolean  "visible",       default: true
    t.boolean  "anonym",        default: false
  end

  add_index "journals", ["created_at"], name: "index_journals_on_created_at", using: :btree
  add_index "journals", ["project_id", "type_event", "user_informed", "viewed"], name: "pr_te_ui_viewd", using: :btree
  add_index "journals", ["project_id", "type_event"], name: "index_journals_on_project_id_and_type_event", using: :btree
  add_index "journals", ["project_id"], name: "index_journals_on_project_id", using: :btree
  add_index "journals", ["type_event"], name: "index_journals_on_type", using: :btree
  add_index "journals", ["user_id"], name: "index_journals_on_user_id", using: :btree

  create_table "life_tape_categories", force: true do |t|
    t.string   "name"
    t.text     "short_desc"
    t.text     "long_desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "life_tape_comment_votings", force: true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "against",    default: true
  end

  add_index "life_tape_comment_votings", ["user_id", "comment_id"], name: "index_life_tape_comment_voitings_on_user_id_and_comment_id", using: :btree

  create_table "life_tape_comments", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.boolean  "censored",          default: false
    t.integer  "comment_id"
    t.boolean  "discontent_status"
    t.boolean  "concept_status"
    t.boolean  "discuss_status"
    t.boolean  "useful"
    t.boolean  "approve_status"
    t.string   "image"
    t.boolean  "isFile"
  end

  add_index "life_tape_comments", ["created_at"], name: "index_life_tape_comments_on_created_at", using: :btree
  add_index "life_tape_comments", ["post_id"], name: "index_life_tape_comments_on_post_id", using: :btree
  add_index "life_tape_comments", ["user_id"], name: "index_life_tape_comments_on_user_id", using: :btree

  create_table "life_tape_post_discussions", force: true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "aspect_id"
  end

  create_table "life_tape_post_votings", force: true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.boolean  "against",    default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "life_tape_post_votings", ["post_id", "user_id"], name: "index_life_tape_post_voitings_on_post_id_and_user_id", using: :btree
  add_index "life_tape_post_votings", ["post_id"], name: "index_life_tape_post_voitings_on_post_id", using: :btree
  add_index "life_tape_post_votings", ["user_id"], name: "index_life_tape_post_voitings_on_user_id", using: :btree

  create_table "life_tape_posts", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "post_id"
    t.integer  "category_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "number_views", default: 0
    t.integer  "project_id"
    t.boolean  "important",    default: false
    t.integer  "aspect_id"
    t.boolean  "censored",     default: false
    t.integer  "status",       default: 0
    t.boolean  "useful"
  end

  add_index "life_tape_posts", ["category_id"], name: "index_life_tape_posts_on_category_id", using: :btree
  add_index "life_tape_posts", ["created_at"], name: "index_life_tape_posts_on_created_at", using: :btree
  add_index "life_tape_posts", ["post_id"], name: "index_life_tape_posts_on_post_id", using: :btree
  add_index "life_tape_posts", ["project_id", "status"], name: "index_life_tape_posts_on_project_id_and_status", using: :btree
  add_index "life_tape_posts", ["project_id"], name: "index_life_tape_posts_on_project_id", using: :btree
  add_index "life_tape_posts", ["user_id"], name: "index_life_tape_posts_on_user_id", using: :btree

  create_table "moderator_messages", force: true do |t|
    t.integer  "user_id"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "moderator_messages", ["user_id"], name: "index_moderator_messages_on_user_id", using: :btree

  create_table "plan_comment_votings", force: true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "against",    default: true
  end

  add_index "plan_comment_votings", ["comment_id"], name: "index_plan_comment_voitings_on_comment_id", using: :btree

  create_table "plan_comments", force: true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.text     "content"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.boolean  "censored",          default: false
    t.integer  "comment_id"
    t.boolean  "discontent_status"
    t.boolean  "concept_status"
    t.boolean  "discuss_status"
    t.boolean  "useful"
    t.boolean  "approve_status"
    t.string   "image"
    t.boolean  "isFile"
  end

  add_index "plan_comments", ["post_id"], name: "index_plan_comments_on_post_id", using: :btree

  create_table "plan_notes", force: true do |t|
    t.text     "content"
    t.integer  "post_id"
    t.integer  "user_id"
    t.integer  "type_field"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plan_post_action_resources", force: true do |t|
    t.integer  "post_action_id"
    t.string   "name"
    t.text     "desc"
    t.integer  "resource_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "project_id"
  end

  create_table "plan_post_actions", force: true do |t|
    t.integer  "plan_post_aspect_id"
    t.string   "name"
    t.text     "desc"
    t.date     "date_begin"
    t.date     "date_end"
    t.integer  "status"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "plan_post_aspects", force: true do |t|
    t.integer  "discontent_aspect_id"
    t.integer  "plan_post_id"
    t.text     "positive"
    t.text     "negative"
    t.text     "control"
    t.text     "problems"
    t.text     "reality"
    t.text     "name"
    t.text     "content"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "first_stage"
    t.integer  "concept_post_aspect_id"
    t.text     "positive_r"
    t.text     "negative_r"
    t.text     "obstacles"
    t.text     "positive_s"
    t.text     "negative_s"
    t.text     "control_s"
    t.text     "control_r"
    t.text     "title"
    t.integer  "post_stage_id"
  end

  create_table "plan_post_first_conds", force: true do |t|
    t.integer  "plan_post_id"
    t.integer  "post_aspect_id"
    t.text     "positive"
    t.text     "negative"
    t.text     "control"
    t.text     "problems"
    t.text     "problems_with_resources"
    t.text     "reality"
    t.string   "name"
    t.text     "content"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "plan_post_means", force: true do |t|
    t.string   "name"
    t.text     "desc"
    t.integer  "post_id"
    t.integer  "resource_id"
    t.string   "type_res"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "project_id"
  end

  create_table "plan_post_notes", force: true do |t|
    t.integer  "post_id"
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plan_post_resources", force: true do |t|
    t.string   "name"
    t.text     "desc"
    t.integer  "post_id"
    t.integer  "resource_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "type_res"
    t.integer  "project_id"
    t.integer  "plan_post_resource_id"
    t.integer  "style"
  end

  create_table "plan_post_stages", force: true do |t|
    t.integer  "post_id"
    t.string   "name"
    t.text     "desc"
    t.date     "date_begin"
    t.date     "date_end"
    t.integer  "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plan_post_votings", force: true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "against",    default: true
  end

  add_index "plan_post_votings", ["post_id"], name: "index_plan_post_voitings_on_post_id", using: :btree

  create_table "plan_posts", force: true do |t|
    t.integer  "user_id"
    t.text     "goal"
    t.text     "first_step"
    t.text     "other_steps"
    t.integer  "status"
    t.integer  "number_views"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "project_id"
    t.text     "content"
    t.integer  "step",            default: 1
    t.boolean  "censored",        default: false
    t.text     "plan_first"
    t.text     "plan_other"
    t.text     "plan_control"
    t.string   "name"
    t.integer  "estimate_status"
    t.boolean  "useful"
    t.boolean  "approve_status"
  end

  add_index "plan_posts", ["created_at"], name: "index_plan_posts_on_created_at", using: :btree
  add_index "plan_posts", ["project_id", "status"], name: "index_plan_posts_on_project_id_and_status", using: :btree
  add_index "plan_posts", ["project_id"], name: "index_plan_posts_on_project_id", using: :btree
  add_index "plan_posts", ["user_id"], name: "index_plan_posts_on_user_id", using: :btree

  create_table "plan_task_triplets", force: true do |t|
    t.integer  "post_id"
    t.integer  "position"
    t.boolean  "compulsory"
    t.text     "task"
    t.text     "supply"
    t.text     "howto"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "plan_task_triplets", ["post_id"], name: "index_plan_task_triplets_on_post_id", using: :btree

  create_table "plan_votings", force: true do |t|
    t.integer  "user_id"
    t.integer  "plan_post_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "begin1st"
    t.datetime "end1st"
    t.datetime "begin1stvote"
    t.datetime "end1stvote"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "question_comment_votings", force: true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "question_comment_votings", ["comment_id"], name: "index_question_comment_votings_on_comment_id", using: :btree

  create_table "question_comments", force: true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.text     "content"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "censored",   default: false
  end

  add_index "question_comments", ["post_id"], name: "index_question_comments_on_post_id", using: :btree

  create_table "question_post_votings", force: true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "question_post_votings", ["post_id"], name: "index_question_post_votings_on_post_id", using: :btree

  create_table "question_posts", force: true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.text     "content"
    t.integer  "status"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "number_views", default: 0
    t.boolean  "censored",     default: false
  end

  add_index "question_posts", ["project_id"], name: "index_questions_posts_on_project_id", using: :btree

  create_table "questions_users", id: false, force: true do |t|
    t.integer "question_id"
    t.integer "user_id"
  end

  add_index "questions_users", ["question_id"], name: "index_questions_users_on_question_id", using: :btree
  add_index "questions_users", ["user_id"], name: "index_questions_users_on_user_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "seed_migration_data_migrations", force: true do |t|
    t.string   "version"
    t.integer  "runtime"
    t.datetime "migrated_on"
  end

  create_table "test_answers", force: true do |t|
    t.text     "name"
    t.integer  "type_answer"
    t.integer  "test_question_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "test_answers", ["test_question_id"], name: "index_test_answers_on_test_question_id", using: :btree

  create_table "test_attempts", force: true do |t|
    t.integer  "test_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "test_attempts", ["test_id"], name: "index_test_attempts_on_test_id", using: :btree
  add_index "test_attempts", ["user_id"], name: "index_test_attempts_on_user_id", using: :btree

  create_table "test_question_attempts", force: true do |t|
    t.integer  "test_attempt_id"
    t.integer  "test_question_id"
    t.string   "answer"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "test_question_attempts", ["test_attempt_id"], name: "index_test_question_attempts_on_test_attempt_id", using: :btree
  add_index "test_question_attempts", ["test_question_id"], name: "index_test_question_attempts_on_test_question_id", using: :btree

  create_table "test_questions", force: true do |t|
    t.text     "name"
    t.integer  "type_question"
    t.integer  "test_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "order_question"
  end

  add_index "test_questions", ["order_question"], name: "index_test_questions_on_order_question", using: :btree
  add_index "test_questions", ["test_id"], name: "index_test_questions_on_test_id", using: :btree

  create_table "tests", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "project_id"
    t.datetime "begin_date"
    t.datetime "end_date"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.text     "preview"
  end

  add_index "tests", ["begin_date"], name: "index_tests_on_begin_date", using: :btree
  add_index "tests", ["end_date"], name: "index_tests_on_end_date", using: :btree

  create_table "user_checks", force: true do |t|
    t.integer  "user_id"
    t.string   "check_field"
    t.boolean  "status"
    t.integer  "project_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "value"
  end

  create_table "user_roles", force: true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_roles", ["role_id"], name: "index_user_roles_on_role_id", using: :btree
  add_index "user_roles", ["user_id"], name: "index_user_roles_on_user_id", using: :btree

  create_table "users", force: true do |t|
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
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "encrypted_password"
    t.string   "login"
    t.string   "salt"
    t.integer  "score",                  default: 0
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "nickname"
    t.boolean  "anonym",                 default: false
    t.integer  "score_a",                default: 0
    t.integer  "score_g",                default: 0
    t.integer  "score_o",                default: 0
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "last_seen"
    t.integer  "type_user"
    t.integer  "role_stat"
    t.datetime "last_seen_news"
    t.boolean  "chat_open",              default: false
    t.datetime "last_seen_chat_at"
    t.string   "locale"
    t.string   "skype"
    t.string   "phone"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "voitings", force: true do |t|
    t.integer  "user_id"
    t.integer  "frustration_id"
    t.integer  "score"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

end
