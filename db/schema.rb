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

ActiveRecord::Schema.define(:version => 20130608142648) do

  create_table "attachments", :force => true do |t|
    t.string   "attachment_file_name"
    t.string   "attachment_link_text"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.integer  "nursing_home_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "attachments", ["nursing_home_id"], :name => "index_attachments_on_nursing_home_id"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "categorizations", :force => true do |t|
    t.integer  "category_id"
    t.integer  "nursing_home_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "images", :force => true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.integer  "position"
    t.datetime "image_updated_at"
    t.integer  "nursing_home_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "images", ["nursing_home_id"], :name => "index_images_on_nursing_home_id"

  create_table "nursing_homes", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "address"
    t.string   "post_code"
    t.string   "postal_town"
    t.string   "neighborhood"
    t.integer  "geo_position_x"
    t.integer  "geo_position_y"
    t.string   "phone"
    t.string   "fax"
    t.string   "url"
    t.string   "email"
    t.string   "owner_type"
    t.string   "owner"
    t.text     "standard"
    t.integer  "seats"
    t.integer  "quality_environment"
    t.integer  "quality_activities"
    t.integer  "quality_food"
    t.integer  "quality_safety"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.string   "rent"
    t.integer  "survey_year"
    t.boolean  "draft",                 :default => false
    t.integer  "quality_average"
    t.integer  "quality_consideration"
  end

  add_index "nursing_homes", ["name"], :name => "index_nursing_homes_on_name"
  add_index "nursing_homes", ["neighborhood"], :name => "index_nursing_homes_on_neighborhood"
  add_index "nursing_homes", ["owner_type"], :name => "index_nursing_homes_on_owner_type"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "displayname"
    t.string   "email"
    t.boolean  "is_admin"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
