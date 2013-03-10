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

ActiveRecord::Schema.define(:version => 20130310124022) do

  create_table "ascents", :force => true do |t|
    t.integer  "boulder_id"
    t.integer  "participant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
    t.boolean  "power"
  end

  create_table "boulders", :force => true do |t|
    t.string   "color"
    t.integer  "relax_points", :default => 1000
    t.integer  "power_points", :default => 1000
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "power_number"
    t.string   "relax_number"
  end

  create_table "participants", :force => true do |t|
    t.integer  "uid"
    t.string   "name"
    t.string   "given_name"
    t.string   "location"
    t.string   "gender"
    t.string   "difficult_boulder"
    t.integer  "age"
    t.boolean  "student"
    t.boolean  "power"
    t.boolean  "private"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "web_participants_id"
  end

  create_table "settings", :force => true do |t|
    t.string   "ranking_city"
    t.string   "ranking_tabs"
    t.string   "colors"
    t.string   "relax_colors"
    t.string   "power_colors"
    t.boolean  "power"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                                 :null => false
    t.string   "email",              :default => "",    :null => false
    t.string   "crypted_password",                      :null => false
    t.string   "password_salt",                         :null => false
    t.boolean  "active",             :default => false, :null => false
    t.integer  "login_count",        :default => 0,     :null => false
    t.integer  "failed_login_count", :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "persistence_token",                     :null => false
  end

end
