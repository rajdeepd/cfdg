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

ActiveRecord::Schema.define(:version => 20121220091714) do

  create_table "announcements", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "user_id"
    t.datetime "deleted_at"
  end

  create_table "chapter_members", :force => true do |t|
    t.integer  "chapter_id",   :null => false
    t.integer  "user_id",      :null => false
    t.string   "memeber_type"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "deleted_at"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "chapters", :force => true do |t|
    t.string   "name"
    t.string   "chapter_type"
    t.string   "chapter_status"
    t.string   "country_id"
    t.string   "state_id"
    t.string   "city_id"
    t.string   "locality"
    t.string   "address"
    t.string   "landmark"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "deleted_at"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "city_name"
    t.string   "state_name"
    t.string   "country_name"
    t.datetime "approved_on"
    t.datetime "rejected_on"
    t.string   "institution",    :default => ""
  end

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.integer  "state_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "deleted_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                  :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_ckeditor_assetable_type"

  create_table "comments", :force => true do |t|
    t.string   "content"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "deleted_at"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "deleted_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "event_members", :force => true do |t|
    t.integer  "event_id",   :null => false
    t.integer  "user_id",    :null => false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "deleted_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "eventbrite_oauth_tokens", :force => true do |t|
    t.integer  "user_id"
    t.string   "event_brite_token"
    t.string   "user_email"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "deleted_at"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "events", :force => true do |t|
    t.string   "title"
    t.string   "event_start_date"
    t.string   "event_end_date"
    t.string   "status"
    t.string   "description"
    t.string   "entry_fee"
    t.string   "venue"
    t.integer  "chapter_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "deleted_at"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "location"
    t.string   "address_line1"
    t.string   "address_line2"
    t.string   "event_start_time"
    t.string   "event_end_time"
    t.string   "city_name"
    t.string   "postal_code"
    t.string   "state_name"
    t.string   "country_name"
    t.string   "eventbrite_id"
    t.text     "agenda_and_speakers"
    t.string   "image"
    t.integer  "attendees_count"
    t.boolean  "is_cancelled"
  end

  create_table "geolocations", :force => true do |t|
    t.string   "latitude"
    t.string   "longitude"
    t.string   "title"
    t.integer  "chapter_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "mail_messages", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "received_id"
    t.string   "subject"
    t.text     "body"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.datetime "deleted_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "messages", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "received_id"
    t.integer  "chapter_id"
    t.text     "body"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.datetime "deleted_at"
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.string   "status"
    t.string   "description"
    t.integer  "chapter_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "deleted_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "event_id"
    t.string   "event_title"
  end

  create_table "states", :force => true do |t|
    t.string   "name"
    t.integer  "country_id"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "deleted_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "fullname"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "deleted_at"
    t.string   "mobile"
    t.string   "website_url"
    t.string   "linkedin_url"
    t.string   "twitter_url"
    t.string   "location"
    t.boolean  "admin",                  :default => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "profile_picture"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
