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

ActiveRecord::Schema.define(:version => 20120906112320) do

  create_table "answers", :force => true do |t|
    t.string   "text"
    t.integer  "raiting"
    t.integer  "user_id"
    t.integer  "question_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "answers", ["created_at"], :name => "index_answers_on_created_at"
  add_index "answers", ["user_id"], :name => "index_answers_on_user_id"

  create_table "comments", :force => true do |t|
    t.string   "commenter"
    t.text     "body"
    t.integer  "post_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "comments", ["post_id"], :name => "index_comments_on_post_id"

  create_table "frustration_comments", :force => true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.integer  "frustration_id"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "negative",       :default => true
    t.string   "comment_admin"
    t.boolean  "trash",          :default => false
  end

  add_index "frustration_comments", ["created_at"], :name => "index_frustration_comments_on_created_at"
  add_index "frustration_comments", ["frustration_id"], :name => "index_frustration_comments_on_frustration_id"
  add_index "frustration_comments", ["user_id"], :name => "index_frustration_comments_on_user_id"

  create_table "frustrations", :force => true do |t|
    t.string   "what"
    t.string   "wherin"
    t.string   "when"
    t.string   "what_old"
    t.string   "wherin_old"
    t.string   "when_old"
    t.integer  "user_id"
    t.integer  "status",           :default => 0
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "old_content"
    t.integer  "negative_user_id"
    t.integer  "struct_user_id"
    t.datetime "structuring_date"
    t.string   "comment_admin"
    t.boolean  "trash"
  end

  add_index "frustrations", ["created_at"], :name => "index_frustrations_on_created_at"
  add_index "frustrations", ["status"], :name => "index_frustrations_on_status"
  add_index "frustrations", ["user_id"], :name => "index_frustrations_on_user_id"

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "text"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "questions", :force => true do |t|
    t.string   "text"
    t.integer  "raiting"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "questions", ["created_at"], :name => "index_questions_on_created_at"
  add_index "questions", ["user_id"], :name => "index_questions_on_user_id"

  create_table "questions_users", :id => false, :force => true do |t|
    t.integer "question_id"
    t.integer "user_id"
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
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "encrypted_password"
    t.string   "login"
    t.string   "salt"
    t.boolean  "admin",              :default => false
    t.integer  "score",              :default => 0
    t.boolean  "expert",             :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
