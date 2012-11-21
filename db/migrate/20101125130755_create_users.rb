class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string   "login", :null => false
      t.string   "email",               :default => "",    :null => false
      t.string   "crypted_password",                       :null => false
      t.string   "password_salt",                          :null => false
      t.boolean  "active",              :default => false, :null => false
      t.integer  "login_count",         :default => 0,     :null => false
      t.integer  "failed_login_count",  :default => 0,     :null => false
      t.datetime "last_request_at"
      t.datetime "current_login_at"
      t.datetime "last_login_at"
      t.string   "current_login_ip"
      t.string   "last_login_ip"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "name"
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
