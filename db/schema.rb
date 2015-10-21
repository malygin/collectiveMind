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

ActiveRecord::Schema.define(version: 20150927191300) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "aspect_answers", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "question_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "status"
    t.boolean  "correct"
  end

  add_index "aspect_answers", ["created_at"], name: "index_aspect_answers_on_created_at", using: :btree
  add_index "aspect_answers", ["question_id"], name: "index_aspect_answers_on_question_id", using: :btree
  add_index "aspect_answers", ["user_id"], name: "index_aspect_answers_on_user_id", using: :btree

  create_table "aspect_comment_votings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.boolean  "against",    default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "aspect_comment_votings", ["comment_id", "user_id"], name: "index_aspect_comment_votings_on_comment_id_and_user_id", using: :btree
  add_index "aspect_comment_votings", ["comment_id"], name: "index_aspect_comment_votings_on_comment_id", using: :btree
  add_index "aspect_comment_votings", ["user_id"], name: "index_aspect_comment_votings_on_user_id", using: :btree

  create_table "aspect_comments", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "post_id"
    t.boolean  "useful"
    t.boolean  "censored",       default: false
    t.integer  "comment_id"
    t.boolean  "discuss_status"
    t.boolean  "approve_status"
    t.string   "image"
    t.boolean  "isFile"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "answer_id"
  end

  add_index "aspect_comments", ["comment_id"], name: "index_aspect_comments_on_comment_id", using: :btree
  add_index "aspect_comments", ["post_id"], name: "index_aspect_comments_on_post_id", using: :btree
  add_index "aspect_comments", ["user_id"], name: "index_aspect_comments_on_user_id", using: :btree

  create_table "aspect_post_votings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.boolean  "against"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "aspect_post_votings", ["post_id", "user_id"], name: "index_aspect_post_votings_on_post_id_and_user_id", using: :btree
  add_index "aspect_post_votings", ["post_id"], name: "index_aspect_post_votings_on_post_id", using: :btree
  add_index "aspect_post_votings", ["user_id"], name: "index_aspect_post_votings_on_user_id", using: :btree

  create_table "aspect_posts", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "position"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "project_id"
    t.text     "short_desc"
    t.integer  "status",               default: 0
    t.integer  "aspect_id"
    t.string   "color"
    t.string   "short_name"
    t.text     "detailed_description"
    t.boolean  "approve_status"
    t.boolean  "useful"
  end

  add_index "aspect_posts", ["aspect_id"], name: "index_aspect_posts_on_aspect_id", using: :btree
  add_index "aspect_posts", ["project_id"], name: "index_aspect_posts_on_project_id", using: :btree
  add_index "aspect_posts", ["user_id"], name: "index_aspect_posts_on_user_id", using: :btree

  create_table "aspect_questions", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "project_id"
    t.integer  "status"
    t.text     "hint"
    t.integer  "aspect_id"
    t.integer  "type_stage"
    t.integer  "type_comment"
  end

  add_index "aspect_questions", ["aspect_id"], name: "index_aspect_questions_on_aspect_id", using: :btree
  add_index "aspect_questions", ["created_at"], name: "index_aspect_questions_on_created_at", using: :btree
  add_index "aspect_questions", ["project_id"], name: "index_aspect_questions_on_project_id", using: :btree
  add_index "aspect_questions", ["user_id"], name: "index_aspect_questions_on_user_id", using: :btree

  create_table "aspect_user_answers", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "answer_id"
    t.integer  "question_id"
    t.integer  "aspect_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "content"
  end

  add_index "aspect_user_answers", ["answer_id"], name: "index_aspect_user_answers_on_answer_id", using: :btree
  add_index "aspect_user_answers", ["aspect_id"], name: "index_aspect_user_answers_on_aspect_id", using: :btree
  add_index "aspect_user_answers", ["project_id"], name: "index_aspect_user_answers_on_project_id", using: :btree
  add_index "aspect_user_answers", ["question_id"], name: "index_aspect_user_answers_on_question_id", using: :btree
  add_index "aspect_user_answers", ["user_id"], name: "index_aspect_user_answers_on_user_id", using: :btree

  create_table "aspect_votings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "aspect_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "status"
  end

  add_index "aspect_votings", ["aspect_id", "user_id"], name: "index_aspect_votings_on_aspect_id_and_user_id", using: :btree
  add_index "aspect_votings", ["aspect_id"], name: "index_aspect_votings_on_aspect_id", using: :btree
  add_index "aspect_votings", ["user_id"], name: "index_aspect_votings_on_user_id", using: :btree

  create_table "awards", force: :cascade do |t|
    t.string  "name",     limit: 255
    t.string  "url",      limit: 255
    t.text    "desc"
    t.integer "position"
  end

  create_table "concept_comment_votings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "against",    default: true
  end

  add_index "concept_comment_votings", ["comment_id", "user_id"], name: "index_concept_comment_votings_on_comment_id_and_user_id", using: :btree
  add_index "concept_comment_votings", ["created_at", "comment_id"], name: "index_concept_comment_voitings_on_created_at_and_comment_id", using: :btree
  add_index "concept_comment_votings", ["user_id"], name: "index_concept_comment_votings_on_user_id", using: :btree

  create_table "concept_comments", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "post_id"
    t.boolean  "useful"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.boolean  "censored",                      default: false
    t.integer  "comment_id"
    t.boolean  "discontent_status"
    t.boolean  "concept_status"
    t.boolean  "discuss_status"
    t.boolean  "approve_status"
    t.string   "image",             limit: 255
    t.boolean  "isFile"
  end

  add_index "concept_comments", ["comment_id"], name: "index_concept_comments_on_comment_id", using: :btree
  add_index "concept_comments", ["created_at"], name: "index_concept_comments_on_created_at", using: :btree
  add_index "concept_comments", ["post_id"], name: "index_concept_comments_on_post_id", using: :btree
  add_index "concept_comments", ["user_id"], name: "index_concept_comments_on_user_id", using: :btree

  create_table "concept_notes", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "post_id"
    t.integer  "type_field"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "concept_notes", ["post_id"], name: "index_concept_notes_on_post_id", using: :btree
  add_index "concept_notes", ["user_id"], name: "index_concept_notes_on_user_id", using: :btree

  create_table "concept_post_discontents", force: :cascade do |t|
    t.integer  "post_id"
    t.integer  "discontent_post_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "complite"
    t.integer  "status"
  end

  add_index "concept_post_discontents", ["discontent_post_id"], name: "index_concept_post_discontents_on_discontent_post_id", using: :btree
  add_index "concept_post_discontents", ["post_id", "discontent_post_id"], name: "concept_post_discontents_post_discontent", using: :btree
  add_index "concept_post_discontents", ["post_id"], name: "index_concept_post_discontents_on_post_id", using: :btree

  create_table "concept_post_resources", force: :cascade do |t|
    t.string   "name",                     limit: 255
    t.text     "desc"
    t.integer  "post_id"
    t.integer  "resource_id"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "project_id"
    t.string   "type_res",                 limit: 255
    t.integer  "concept_post_resource_id"
    t.integer  "style"
  end

  add_index "concept_post_resources", ["post_id"], name: "index_concept_post_resources_on_post_id", using: :btree
  add_index "concept_post_resources", ["project_id"], name: "index_concept_post_resources_on_project_id", using: :btree

  create_table "concept_post_votings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.boolean  "against"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "concept_post_votings", ["post_id", "user_id"], name: "index_concept_post_voitings_on_post_id_and_user_id", using: :btree
  add_index "concept_post_votings", ["post_id", "user_id"], name: "index_concept_post_votings_on_post_id_and_user_id", using: :btree
  add_index "concept_post_votings", ["post_id"], name: "index_concept_post_voitings_on_post_id", using: :btree
  add_index "concept_post_votings", ["user_id"], name: "index_concept_post_voitings_on_user_id", using: :btree

  create_table "concept_posts", force: :cascade do |t|
    t.text     "goal"
    t.integer  "user_id"
    t.integer  "number_views",   default: 0
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "status",         default: 0
    t.integer  "project_id"
    t.text     "content"
    t.boolean  "censored",       default: false
    t.boolean  "discuss_status"
    t.boolean  "useful"
    t.boolean  "approve_status"
    t.text     "title"
    t.text     "actors"
    t.text     "impact_env"
  end

  add_index "concept_posts", ["created_at"], name: "index_concept_posts_on_created_at", using: :btree
  add_index "concept_posts", ["project_id", "status"], name: "index_concept_posts_on_project_id_and_status", using: :btree
  add_index "concept_posts", ["project_id"], name: "index_concept_posts_on_project_id", using: :btree
  add_index "concept_posts", ["status"], name: "index_concept_posts_on_status", using: :btree
  add_index "concept_posts", ["user_id"], name: "index_concept_posts_on_user_id", using: :btree

  create_table "concept_resources", force: :cascade do |t|
    t.string  "name",       limit: 255
    t.text    "desc"
    t.integer "project_id"
  end

  add_index "concept_resources", ["project_id"], name: "index_concept_resources_on_project_id", using: :btree

  create_table "concept_votings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "concept_post_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "discontent_post_id"
    t.integer  "status"
  end

  add_index "concept_votings", ["concept_post_id", "user_id"], name: "index_concept_votings_on_concept_post_id_and_user_id", using: :btree
  add_index "concept_votings", ["concept_post_id"], name: "index_concept_votings_on_concept_post_id", using: :btree
  add_index "concept_votings", ["discontent_post_id"], name: "index_concept_votings_on_discontent_post_id", using: :btree
  add_index "concept_votings", ["user_id"], name: "index_concept_votings_on_user_id", using: :btree

  create_table "core_content_answers", force: :cascade do |t|
    t.text     "content"
    t.integer  "content_question_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "core_content_questions", force: :cascade do |t|
    t.integer  "project_id"
    t.text     "content"
    t.string   "post_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "core_content_questions", ["project_id"], name: "index_core_content_questions_on_project_id", using: :btree

  create_table "core_content_user_answers", force: :cascade do |t|
    t.text     "content"
    t.integer  "content_question_id"
    t.integer  "content_answer_id"
    t.integer  "user_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "post_id"
  end

  add_index "core_content_user_answers", ["content_answer_id"], name: "index_core_content_user_answers_on_content_answer_id", using: :btree
  add_index "core_content_user_answers", ["content_question_id"], name: "index_core_content_user_answers_on_content_question_id", using: :btree
  add_index "core_content_user_answers", ["user_id"], name: "index_core_content_user_answers_on_user_id", using: :btree

  create_table "core_essay_comment_votings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "against"
  end

  add_index "core_essay_comment_votings", ["comment_id", "user_id"], name: "index_core_essay_comment_votings_on_comment_id_and_user_id", using: :btree
  add_index "core_essay_comment_votings", ["comment_id"], name: "index_essay_comment_voitings_on_comment_id", using: :btree
  add_index "core_essay_comment_votings", ["user_id"], name: "index_core_essay_comment_votings_on_user_id", using: :btree

  create_table "core_essay_comments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.text     "content"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.boolean  "censored",                      default: false
    t.integer  "comment_id"
    t.boolean  "discontent_status"
    t.boolean  "concept_status"
    t.boolean  "discuss_status"
    t.boolean  "useful"
    t.boolean  "approve_status"
    t.string   "image",             limit: 255
    t.boolean  "isFile"
  end

  add_index "core_essay_comments", ["comment_id"], name: "index_core_essay_comments_on_comment_id", using: :btree
  add_index "core_essay_comments", ["post_id"], name: "index_core_essay_comments_on_post_id", using: :btree
  add_index "core_essay_comments", ["user_id"], name: "index_core_essay_comments_on_user_id", using: :btree

  create_table "core_essay_post_votings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "against"
  end

  add_index "core_essay_post_votings", ["post_id", "user_id"], name: "index_core_essay_post_votings_on_post_id_and_user_id", using: :btree
  add_index "core_essay_post_votings", ["post_id"], name: "index_essay_post_voitings_on_post_id", using: :btree
  add_index "core_essay_post_votings", ["user_id"], name: "index_core_essay_post_votings_on_user_id", using: :btree

  create_table "core_essay_posts", force: :cascade do |t|
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

  add_index "core_essay_posts", ["project_id"], name: "index_core_essay_posts_on_project_id", using: :btree
  add_index "core_essay_posts", ["user_id"], name: "index_core_essay_posts_on_user_id", using: :btree

  create_table "core_help_posts", force: :cascade do |t|
    t.text     "content"
    t.integer  "stage"
    t.boolean  "mini"
    t.integer  "style"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "title",      limit: 255
  end

  create_table "core_knowbase_posts", force: :cascade do |t|
    t.text     "content"
    t.integer  "project_id"
    t.integer  "stage"
    t.string   "title",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "aspect_id"
  end

  add_index "core_knowbase_posts", ["aspect_id"], name: "index_core_knowbase_posts_on_aspect_id", using: :btree
  add_index "core_knowbase_posts", ["project_id"], name: "index_core_knowbase_posts_on_project_id", using: :btree

  create_table "core_project_scores", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "score",      default: 0
    t.integer  "score_a",    default: 0
    t.integer  "score_g",    default: 0
    t.integer  "score_o",    default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "core_project_scores", ["project_id"], name: "index_core_project_scores_on_project_id", using: :btree
  add_index "core_project_scores", ["user_id"], name: "index_core_project_scores_on_user_id", using: :btree

  create_table "core_project_settings", force: :cascade do |t|
    t.json     "stage_dates"
    t.integer  "project_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "core_project_settings", ["project_id"], name: "index_core_project_settings_on_project_id", using: :btree

  create_table "core_project_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "code"
    t.boolean  "custom_fields", default: false
  end

  create_table "core_project_users", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "ready_to_concept",       default: false
    t.boolean  "ready_to_plan",          default: false
    t.boolean  "owner",                  default: false
    t.integer  "type_user"
    t.integer  "aspect_posts_score",     default: 0
    t.integer  "discontent_posts_score", default: 0
    t.integer  "concept_posts_score",    default: 0
    t.integer  "novation_posts_score",   default: 0
    t.integer  "plan_posts_score",       default: 0
    t.integer  "estimate_posts_score",   default: 0
    t.integer  "score",                  default: 0
  end

  add_index "core_project_users", ["project_id", "user_id"], name: "index_core_project_users_on_project_id_and_user_id", using: :btree
  add_index "core_project_users", ["project_id"], name: "index_core_project_users_on_project_id", using: :btree
  add_index "core_project_users", ["user_id"], name: "index_core_project_users_on_user_id", using: :btree

  create_table "core_projects", force: :cascade do |t|
    t.string   "name",            limit: 500
    t.text     "desc"
    t.text     "short_desc"
    t.integer  "status",                      default: 1
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "url_logo",        limit: 255
    t.integer  "type_access"
    t.integer  "position",                    default: 0
    t.string   "color",           limit: 255
    t.string   "code",            limit: 255
    t.integer  "moderator_id"
    t.date     "date_start"
    t.date     "date_end"
    t.text     "completion_text"
    t.string   "stage",                       default: "0"
    t.integer  "project_type_id"
    t.text     "introduction"
  end

  add_index "core_projects", ["status"], name: "index_core_projects_on_status", using: :btree

  create_table "core_user_award_clicks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "clicks",     default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "core_user_award_clicks", ["project_id"], name: "index_core_user_award_clicks_on_project_id", using: :btree
  add_index "core_user_award_clicks", ["user_id"], name: "index_core_user_award_clicks_on_user_id", using: :btree

  create_table "core_user_awards", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "award_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "project_id"
    t.integer  "position"
  end

  add_index "core_user_awards", ["award_id", "user_id"], name: "index_core_user_awards_on_award_id_and_user_id", using: :btree
  add_index "core_user_awards", ["award_id"], name: "index_core_user_awards_on_award_id", using: :btree
  add_index "core_user_awards", ["project_id"], name: "index_core_user_awards_on_project_id", using: :btree
  add_index "core_user_awards", ["user_id"], name: "index_core_user_awards_on_user_id", using: :btree

  create_table "discontent_comment_votings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "against",    default: true
  end

  add_index "discontent_comment_votings", ["comment_id", "user_id"], name: "index_discontent_comment_votings_on_comment_id_and_user_id", using: :btree
  add_index "discontent_comment_votings", ["comment_id"], name: "index_discontent_comment_voitings_on_comment_id", using: :btree
  add_index "discontent_comment_votings", ["user_id"], name: "index_discontent_comment_votings_on_user_id", using: :btree

  create_table "discontent_comments", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.boolean  "censored",                      default: false
    t.integer  "comment_id"
    t.boolean  "discontent_status"
    t.boolean  "concept_status"
    t.boolean  "discuss_status"
    t.boolean  "useful"
    t.boolean  "approve_status"
    t.string   "image",             limit: 255
    t.boolean  "isFile"
  end

  add_index "discontent_comments", ["comment_id"], name: "index_discontent_comments_on_comment_id", using: :btree
  add_index "discontent_comments", ["post_id"], name: "index_discontent_comments_on_post_id", using: :btree
  add_index "discontent_comments", ["user_id"], name: "index_discontent_comments_on_user_id", using: :btree

  create_table "discontent_notes", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "post_id"
    t.integer  "type_field"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "discontent_notes", ["post_id"], name: "index_discontent_notes_on_post_id", using: :btree
  add_index "discontent_notes", ["user_id"], name: "index_discontent_notes_on_user_id", using: :btree

  create_table "discontent_post_aspects", force: :cascade do |t|
    t.integer  "post_id"
    t.integer  "aspect_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "discontent_post_aspects", ["aspect_id", "post_id"], name: "index_discontent_post_aspects_on_aspect_id_and_post_id", using: :btree
  add_index "discontent_post_aspects", ["aspect_id"], name: "index_discontent_post_aspects_on_aspect_id", using: :btree
  add_index "discontent_post_aspects", ["post_id"], name: "index_discontent_post_aspects_on_post_id", using: :btree

  create_table "discontent_post_votings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "against",    default: true
  end

  add_index "discontent_post_votings", ["post_id", "user_id"], name: "index_discontent_post_voitings_on_post_id_and_user_id", using: :btree
  add_index "discontent_post_votings", ["post_id", "user_id"], name: "index_discontent_post_votings_on_post_id_and_user_id", using: :btree
  add_index "discontent_post_votings", ["post_id"], name: "index_discontent_post_voitings_on_post_id", using: :btree
  add_index "discontent_post_votings", ["user_id"], name: "index_discontent_post_voitings_on_user_id", using: :btree

  create_table "discontent_post_whens", force: :cascade do |t|
    t.string  "content",    limit: 255
    t.integer "project_id"
  end

  add_index "discontent_post_whens", ["project_id"], name: "index_discontent_post_whens_on_project_id", using: :btree

  create_table "discontent_post_wheres", force: :cascade do |t|
    t.string  "content",    limit: 255
    t.integer "project_id"
  end

  add_index "discontent_post_wheres", ["project_id"], name: "index_discontent_post_wheres_on_project_id", using: :btree

  create_table "discontent_posts", force: :cascade do |t|
    t.text     "content"
    t.text     "whend"
    t.text     "whered"
    t.integer  "user_id"
    t.integer  "status",             default: 0
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "number_views",       default: 0
    t.integer  "project_id"
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
    t.boolean  "anonym"
    t.text     "what"
  end

  add_index "discontent_posts", ["discontent_post_id"], name: "index_discontent_posts_on_discontent_post_id", using: :btree
  add_index "discontent_posts", ["project_id", "status"], name: "index_discontent_posts_on_project_id_and_status", using: :btree
  add_index "discontent_posts", ["project_id"], name: "index_discontent_posts_on_project_id", using: :btree
  add_index "discontent_posts", ["user_id"], name: "index_discontent_posts_on_user_id", using: :btree

  create_table "discontent_votings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "discontent_post_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.boolean  "against"
    t.integer  "status"
  end

  add_index "discontent_votings", ["discontent_post_id", "user_id"], name: "index_discontent_votings_on_discontent_post_id_and_user_id", using: :btree
  add_index "discontent_votings", ["discontent_post_id"], name: "index_discontent_votings_on_discontent_post_id", using: :btree
  add_index "discontent_votings", ["user_id"], name: "index_discontent_votings_on_user_id", using: :btree

  create_table "estimate_comment_votings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "against",    default: true
  end

  add_index "estimate_comment_votings", ["comment_id", "user_id"], name: "index_estimate_comment_votings_on_comment_id_and_user_id", using: :btree
  add_index "estimate_comment_votings", ["comment_id"], name: "index_estimate_comment_voitings_on_comment_id", using: :btree
  add_index "estimate_comment_votings", ["user_id"], name: "index_estimate_comment_votings_on_user_id", using: :btree

  create_table "estimate_comments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.text     "content"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.boolean  "censored",                      default: false
    t.integer  "comment_id"
    t.boolean  "discontent_status"
    t.boolean  "concept_status"
    t.boolean  "discuss_status"
    t.boolean  "useful"
    t.boolean  "approve_status"
    t.string   "image",             limit: 255
    t.boolean  "isFile"
  end

  add_index "estimate_comments", ["comment_id"], name: "index_estimate_comments_on_comment_id", using: :btree
  add_index "estimate_comments", ["post_id"], name: "index_estimate_comments_on_post_id", using: :btree
  add_index "estimate_comments", ["user_id"], name: "index_estimate_comments_on_user_id", using: :btree

  create_table "estimate_post_aspects", force: :cascade do |t|
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

  add_index "estimate_post_aspects", ["plan_post_aspect_id"], name: "index_estimate_post_aspects_on_plan_post_aspect_id", using: :btree
  add_index "estimate_post_aspects", ["post_id"], name: "index_estimate_post_aspects_on_post_id", using: :btree

  create_table "estimate_post_votings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.boolean  "against"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "estimate_post_votings", ["post_id", "user_id"], name: "index_estimate_post_votings_on_post_id_and_user_id", using: :btree
  add_index "estimate_post_votings", ["post_id"], name: "index_estimate_post_votings_on_post_id", using: :btree
  add_index "estimate_post_votings", ["user_id"], name: "index_estimate_post_votings_on_user_id", using: :btree

  create_table "estimate_posts", force: :cascade do |t|
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

  create_table "estimate_votings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "estimate_post_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "status"
  end

  add_index "estimate_votings", ["estimate_post_id"], name: "index_estimate_votings_on_estimate_post_id", using: :btree
  add_index "estimate_votings", ["user_id"], name: "index_estimate_votings_on_user_id", using: :btree

  create_table "group_chat_messages", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_chat_messages", ["group_id"], name: "index_group_chat_messages_on_group_id", using: :btree
  add_index "group_chat_messages", ["user_id"], name: "index_group_chat_messages_on_user_id", using: :btree

  create_table "group_task_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_task_users", ["group_task_id"], name: "index_group_task_users_on_group_task_id", using: :btree
  add_index "group_task_users", ["user_id"], name: "index_group_task_users_on_user_id", using: :btree

  create_table "group_tasks", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",                  default: 10
  end

  add_index "group_tasks", ["group_id"], name: "index_group_tasks_on_group_id", using: :btree

  create_table "group_users", force: :cascade do |t|
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

  create_table "groups", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["project_id"], name: "index_groups_on_project_id", using: :btree

  create_table "journal_loggers", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "type_event"
    t.text     "body"
    t.integer  "project_id"
    t.integer  "first_id"
    t.integer  "second_id"
    t.string   "body2"
    t.integer  "user_informed"
    t.boolean  "viewed"
    t.boolean  "personal",       default: false
    t.boolean  "visible",        default: true
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "request_format"
  end

  add_index "journal_loggers", ["project_id"], name: "index_journal_loggers_on_project_id", using: :btree
  add_index "journal_loggers", ["user_id", "project_id", "type_event"], name: "index_journal_loggers_on_user_id_and_project_id_and_type_event", using: :btree
  add_index "journal_loggers", ["user_id"], name: "index_journal_loggers_on_user_id", using: :btree

  create_table "journal_mailers", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.text     "content"
    t.integer  "user_id"
    t.integer  "project_id"
    t.integer  "status"
    t.boolean  "sent"
    t.boolean  "viewed",                 default: false
    t.boolean  "visible",                default: true
    t.integer  "receiver"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "journal_mailers", ["project_id"], name: "index_journal_mailers_on_project_id", using: :btree
  add_index "journal_mailers", ["user_id"], name: "index_journal_mailers_on_user_id", using: :btree

  create_table "journals", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "type_event",    limit: 255
    t.text     "body"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "project_id"
    t.integer  "user_informed"
    t.boolean  "viewed"
    t.integer  "event"
    t.integer  "first_id"
    t.integer  "second_id"
    t.boolean  "personal",                  default: false
    t.string   "body2",         limit: 255
    t.boolean  "visible",                   default: true
    t.boolean  "anonym",                    default: false
  end

  add_index "journals", ["created_at"], name: "index_journals_on_created_at", using: :btree
  add_index "journals", ["project_id", "type_event", "user_informed", "viewed"], name: "pr_te_ui_viewd", using: :btree
  add_index "journals", ["project_id", "type_event"], name: "index_journals_on_project_id_and_type_event", using: :btree
  add_index "journals", ["project_id"], name: "index_journals_on_project_id", using: :btree
  add_index "journals", ["type_event"], name: "index_journals_on_type", using: :btree
  add_index "journals", ["user_id"], name: "index_journals_on_user_id", using: :btree

  create_table "moderator_messages", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "moderator_messages", ["user_id"], name: "index_moderator_messages_on_user_id", using: :btree

  create_table "news", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.text     "body"
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "news", ["project_id"], name: "index_news_on_project_id", using: :btree
  add_index "news", ["user_id"], name: "index_news_on_user_id", using: :btree

  create_table "novation_comment_votings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.boolean  "against",    default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "novation_comment_votings", ["comment_id", "user_id"], name: "index_novation_comment_votings_on_comment_id_and_user_id", using: :btree
  add_index "novation_comment_votings", ["comment_id"], name: "index_novation_comment_votings_on_comment_id", using: :btree
  add_index "novation_comment_votings", ["user_id"], name: "index_novation_comment_votings_on_user_id", using: :btree

  create_table "novation_comments", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "post_id"
    t.boolean  "useful"
    t.boolean  "censored",       default: false
    t.integer  "comment_id"
    t.boolean  "discuss_status"
    t.boolean  "approve_status"
    t.string   "image"
    t.boolean  "isFile"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "novation_comments", ["comment_id"], name: "index_novation_comments_on_comment_id", using: :btree
  add_index "novation_comments", ["post_id"], name: "index_novation_comments_on_post_id", using: :btree
  add_index "novation_comments", ["user_id"], name: "index_novation_comments_on_user_id", using: :btree

  create_table "novation_notes", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "post_id"
    t.integer  "type_field"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "novation_notes", ["post_id"], name: "index_novation_notes_on_post_id", using: :btree
  add_index "novation_notes", ["user_id"], name: "index_novation_notes_on_user_id", using: :btree

  create_table "novation_post_concepts", force: :cascade do |t|
    t.integer  "post_id"
    t.integer  "concept_post_id"
    t.integer  "status",          default: 0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "novation_post_concepts", ["concept_post_id", "post_id"], name: "index_novation_post_concepts_on_concept_post_id_and_post_id", using: :btree
  add_index "novation_post_concepts", ["concept_post_id"], name: "index_novation_post_concepts_on_concept_post_id", using: :btree
  add_index "novation_post_concepts", ["post_id"], name: "index_novation_post_concepts_on_post_id", using: :btree

  create_table "novation_post_votings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.boolean  "against"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "novation_post_votings", ["post_id", "user_id"], name: "index_novation_post_votings_on_post_id_and_user_id", using: :btree
  add_index "novation_post_votings", ["post_id"], name: "index_novation_post_votings_on_post_id", using: :btree
  add_index "novation_post_votings", ["user_id"], name: "index_novation_post_votings_on_user_id", using: :btree

  create_table "novation_posts", force: :cascade do |t|
    t.string   "title"
    t.integer  "user_id"
    t.integer  "number_views",                      default: 0
    t.integer  "status",                            default: 0
    t.integer  "project_id"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.text     "content"
    t.text     "project_change"
    t.text     "project_goal"
    t.text     "project_members"
    t.text     "project_results"
    t.text     "project_time"
    t.text     "members_new"
    t.text     "members_who"
    t.text     "members_education"
    t.text     "members_motivation"
    t.text     "members_execute"
    t.text     "resource_commands"
    t.text     "resource_support"
    t.text     "resource_internal"
    t.text     "resource_external"
    t.text     "resource_financial"
    t.text     "resource_competition"
    t.text     "confidence_commands"
    t.text     "confidence_remove_discontent"
    t.text     "confidence_negative_results"
    t.boolean  "approve_status"
    t.boolean  "project_change_bool"
    t.boolean  "project_goal_bool"
    t.boolean  "project_members_bool"
    t.boolean  "project_results_bool"
    t.boolean  "project_time_bool"
    t.boolean  "members_new_bool"
    t.boolean  "members_who_bool"
    t.boolean  "members_education_bool"
    t.boolean  "members_motivation_bool"
    t.boolean  "members_execute_bool"
    t.boolean  "resource_commands_bool"
    t.boolean  "resource_support_bool"
    t.boolean  "resource_internal_bool"
    t.boolean  "resource_external_bool"
    t.boolean  "resource_financial_bool"
    t.boolean  "resource_competition_bool"
    t.boolean  "confidence_commands_bool"
    t.boolean  "confidence_remove_discontent_bool"
    t.boolean  "confidence_negative_results_bool"
    t.integer  "fullness"
    t.boolean  "useful"
  end

  add_index "novation_posts", ["project_id"], name: "index_novation_posts_on_project_id", using: :btree
  add_index "novation_posts", ["user_id"], name: "index_novation_posts_on_user_id", using: :btree

  create_table "novation_votings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "novation_post_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "status"
  end

  add_index "novation_votings", ["novation_post_id", "user_id"], name: "index_novation_votings_on_novation_post_id_and_user_id", using: :btree
  add_index "novation_votings", ["novation_post_id"], name: "index_novation_votings_on_novation_post_id", using: :btree
  add_index "novation_votings", ["user_id"], name: "index_novation_votings_on_user_id", using: :btree

  create_table "plan_comment_votings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "against",    default: true
  end

  add_index "plan_comment_votings", ["comment_id", "user_id"], name: "index_plan_comment_votings_on_comment_id_and_user_id", using: :btree
  add_index "plan_comment_votings", ["comment_id"], name: "index_plan_comment_voitings_on_comment_id", using: :btree
  add_index "plan_comment_votings", ["user_id"], name: "index_plan_comment_votings_on_user_id", using: :btree

  create_table "plan_comments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.text     "content"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.boolean  "censored",                      default: false
    t.integer  "comment_id"
    t.boolean  "discontent_status"
    t.boolean  "concept_status"
    t.boolean  "discuss_status"
    t.boolean  "useful"
    t.boolean  "approve_status"
    t.string   "image",             limit: 255
    t.boolean  "isFile"
  end

  add_index "plan_comments", ["comment_id"], name: "index_plan_comments_on_comment_id", using: :btree
  add_index "plan_comments", ["post_id"], name: "index_plan_comments_on_post_id", using: :btree
  add_index "plan_comments", ["user_id"], name: "index_plan_comments_on_user_id", using: :btree

  create_table "plan_notes", force: :cascade do |t|
    t.text     "content"
    t.integer  "post_id"
    t.integer  "user_id"
    t.integer  "type_field"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "plan_notes", ["post_id"], name: "index_plan_notes_on_post_id", using: :btree
  add_index "plan_notes", ["user_id"], name: "index_plan_notes_on_user_id", using: :btree

  create_table "plan_post_aspects", force: :cascade do |t|
    t.integer  "core_aspect_id"
    t.integer  "plan_post_id"
    t.text     "positive"
    t.text     "negative"
    t.text     "control"
    t.text     "problems"
    t.text     "reality"
    t.text     "name"
    t.text     "content"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "first_stage"
    t.integer  "concept_post_id"
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

  create_table "plan_post_novations", force: :cascade do |t|
    t.integer  "novation_post_id"
    t.integer  "plan_post_id"
    t.string   "title"
    t.text     "project_change"
    t.text     "project_goal"
    t.text     "project_members"
    t.text     "project_results"
    t.text     "project_time"
    t.text     "members_new"
    t.text     "members_who"
    t.text     "members_education"
    t.text     "members_motivation"
    t.text     "members_execute"
    t.text     "resource_commands"
    t.text     "resource_support"
    t.text     "resource_internal"
    t.text     "resource_external"
    t.text     "resource_financial"
    t.text     "resource_competition"
    t.text     "confidence_commands"
    t.text     "confidence_remove_discontent"
    t.text     "confidence_negative_results"
    t.boolean  "project_change_bool"
    t.boolean  "project_goal_bool"
    t.boolean  "project_members_bool"
    t.boolean  "project_results_bool"
    t.boolean  "project_time_bool"
    t.boolean  "members_new_bool"
    t.boolean  "members_who_bool"
    t.boolean  "members_education_bool"
    t.boolean  "members_motivation_bool"
    t.boolean  "members_execute_bool"
    t.boolean  "resource_commands_bool"
    t.boolean  "resource_support_bool"
    t.boolean  "resource_internal_bool"
    t.boolean  "resource_external_bool"
    t.boolean  "resource_financial_bool"
    t.boolean  "resource_competition_bool"
    t.boolean  "confidence_commands_bool"
    t.boolean  "confidence_remove_discontent_bool"
    t.boolean  "confidence_negative_results_bool"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "plan_post_novations", ["novation_post_id"], name: "index_plan_post_novations_on_novation_post_id", using: :btree
  add_index "plan_post_novations", ["plan_post_id"], name: "index_plan_post_novations_on_plan_post_id", using: :btree

  create_table "plan_post_votings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "against",    default: true
  end

  add_index "plan_post_votings", ["post_id", "user_id"], name: "index_plan_post_votings_on_post_id_and_user_id", using: :btree
  add_index "plan_post_votings", ["post_id"], name: "index_plan_post_voitings_on_post_id", using: :btree
  add_index "plan_post_votings", ["user_id"], name: "index_plan_post_votings_on_user_id", using: :btree

  create_table "plan_posts", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "goal"
    t.text     "first_step"
    t.text     "other_steps"
    t.integer  "status",                        default: 0
    t.integer  "number_views",                  default: 0
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "project_id"
    t.text     "content"
    t.integer  "step",                          default: 1
    t.boolean  "censored",                      default: false
    t.text     "plan_first"
    t.text     "plan_other"
    t.text     "plan_control"
    t.string   "name",              limit: 255
    t.integer  "estimate_status"
    t.boolean  "useful"
    t.boolean  "approve_status"
    t.json     "tasks_gant"
    t.boolean  "completion_status"
  end

  add_index "plan_posts", ["created_at"], name: "index_plan_posts_on_created_at", using: :btree
  add_index "plan_posts", ["project_id", "status"], name: "index_plan_posts_on_project_id_and_status", using: :btree
  add_index "plan_posts", ["project_id"], name: "index_plan_posts_on_project_id", using: :btree
  add_index "plan_posts", ["user_id"], name: "index_plan_posts_on_user_id", using: :btree

  create_table "plan_votings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "plan_post_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "status"
    t.integer  "type_vote"
  end

  add_index "plan_votings", ["plan_post_id", "user_id"], name: "index_plan_votings_on_plan_post_id_and_user_id", using: :btree
  add_index "plan_votings", ["plan_post_id"], name: "index_plan_votings_on_plan_post_id", using: :btree
  add_index "plan_votings", ["user_id"], name: "index_plan_votings_on_user_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "seed_migration_data_migrations", force: :cascade do |t|
    t.string   "version"
    t.integer  "runtime"
    t.datetime "migrated_on"
  end

  create_table "skills", force: :cascade do |t|
    t.string   "name"
    t.integer  "award_size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "technique_list_projects", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "technique_list_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "technique_list_projects", ["project_id", "technique_list_id"], name: "technique_list_projects_project_list", using: :btree
  add_index "technique_list_projects", ["project_id"], name: "index_technique_list_projects_on_project_id", using: :btree
  add_index "technique_list_projects", ["technique_list_id"], name: "index_technique_list_projects_on_technique_list_id", using: :btree

  create_table "technique_lists", force: :cascade do |t|
    t.string   "stage"
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "technique_skills", force: :cascade do |t|
    t.integer  "technique_list_id"
    t.integer  "skill_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "technique_skills", ["skill_id"], name: "index_technique_skills_on_skill_id", using: :btree
  add_index "technique_skills", ["technique_list_id"], name: "index_technique_skills_on_technique_list_id", using: :btree

  create_table "technique_stores", force: :cascade do |t|
    t.integer  "technique_list_project_id"
    t.integer  "user_id"
    t.integer  "post_id"
    t.json     "params"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "technique_stores", ["technique_list_project_id"], name: "index_technique_stores_on_technique_list_project_id", using: :btree
  add_index "technique_stores", ["user_id"], name: "index_technique_stores_on_user_id", using: :btree

  create_table "user_checks", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "check_field", limit: 255
    t.boolean  "status"
    t.integer  "project_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "value",       limit: 255
  end

  add_index "user_checks", ["user_id"], name: "index_user_checks_on_user_id", using: :btree

  create_table "user_roles", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_roles", ["role_id"], name: "index_user_roles_on_role_id", using: :btree
  add_index "user_roles", ["user_id"], name: "index_user_roles_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.string   "surname",                limit: 255
    t.string   "email",                  limit: 255
    t.string   "group",                  limit: 255
    t.string   "string",                 limit: 255
    t.string   "faculty",                limit: 255
    t.date     "dateRegistration"
    t.date     "dateActivation"
    t.date     "dateLastEnter"
    t.string   "vkid",                   limit: 255
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "encrypted_password",     limit: 255
    t.string   "login",                  limit: 255
    t.string   "salt",                   limit: 255
    t.integer  "score",                              default: 0
    t.string   "nickname",               limit: 255
    t.boolean  "anonym",                             default: false
    t.integer  "score_a",                            default: 0
    t.integer  "score_g",                            default: 0
    t.integer  "score_o",                            default: 0
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.datetime "last_seen"
    t.integer  "type_user"
    t.integer  "role_stat"
    t.datetime "last_seen_news"
    t.boolean  "chat_open",                          default: false
    t.datetime "last_seen_chat_at"
    t.string   "skype",                  limit: 255
    t.string   "phone",                  limit: 255
    t.string   "locale",                 limit: 255
    t.string   "avatar"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "technique_list_projects", "core_projects", column: "project_id"
  add_foreign_key "technique_list_projects", "technique_lists"
  add_foreign_key "technique_skills", "skills"
  add_foreign_key "technique_skills", "technique_lists"
  add_foreign_key "technique_stores", "technique_list_projects"
  add_foreign_key "technique_stores", "users"
end
