# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 40) do

  create_table "blogposts", :force => true do |t|
    t.integer  "blog_id"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "sendout",            :limit => 1, :default => 1
    t.string   "membershiptype_ids"
  end

  create_table "blogs", :force => true do |t|
    t.integer  "user_id"
    t.integer  "club_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bookings", :force => true do |t|
    t.integer  "user_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "duration"
    t.integer  "no_ergs"
    t.integer  "weights"
    t.integer  "club_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clubs", :force => true do |t|
    t.string  "name",                             :default => ""
    t.string  "initials",                         :default => ""
    t.integer "sport_id",                         :default => 0
    t.string  "locationcode",                     :default => ""
    t.string  "backgroundcolor",     :limit => 7
    t.integer "season_begins_day",   :limit => 2
    t.integer "season_begins_month", :limit => 2
    t.string  "officialsite",        :limit => 3, :default => "No"
    t.string  "website"
  end

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "blogpost_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "committeemembers", :force => true do |t|
    t.integer  "committee_id"
    t.integer  "user_id"
    t.string   "position"
    t.string   "position_email2"
    t.string   "position_email"
    t.integer  "roworder"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "committees", :force => true do |t|
    t.integer  "club_id"
    t.datetime "elected_on"
    t.datetime "in_office_from"
    t.string   "description"
    t.string   "groupemail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "data_sports", :force => true do |t|
    t.string "name"
  end

  create_table "data_uk_geo", :force => true do |t|
    t.string  "locationcode"
    t.integer "x"
    t.integer "y"
    t.float   "latitude"
    t.float   "longitude"
  end

  add_index "data_uk_geo", ["locationcode"], :name => "locationcode_optimization"

  create_table "data_uk_towns", :force => true do |t|
    t.string  "locationcode"
    t.string  "district"
    t.integer "x"
    t.integer "y"
    t.float   "latitude"
    t.float   "longitude"
  end

  create_table "data_us_geos", :force => true do |t|
    t.string "locationcode"
    t.float  "latitude"
    t.float  "longitude"
    t.string "city"
    t.string "state"
    t.string "county"
    t.string "type"
  end

  add_index "data_us_geos", ["locationcode"], :name => "locationcode_optimization"

  create_table "datacountrys", :force => true do |t|
    t.string "name"
  end

  create_table "dataestatuses", :force => true do |t|
    t.string  "description"
    t.integer "roworder"
  end

  create_table "dataetypes", :force => true do |t|
    t.string  "description"
    t.integer "roworder"
  end

  create_table "events", :force => true do |t|
    t.date     "date"
    t.string   "title"
    t.text     "description"
    t.datetime "when_entries_open"
    t.datetime "when_entries_close"
    t.integer  "sport_id"
    t.integer  "club_id"
    t.time     "start_time"
    t.integer  "user_id"
    t.string   "created_by_owner"
    t.integer  "dataetype_id"
    t.string   "venue"
    t.integer  "datacountry_id"
    t.string   "locationcode"
    t.integer  "num_of_categories"
    t.string   "ind_or_team",        :limit => 10
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forums", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "topics_count",                    :default => 0
    t.integer  "posts_count",                     :default => 0
    t.integer  "position"
    t.text     "description_html"
    t.integer  "club_id"
    t.integer  "team_id"
    t.integer  "membershiptype_id"
    t.integer  "allmembershiptypes", :limit => 1, :default => 0
    t.integer  "priveleged",         :limit => 1, :default => 0
    t.integer  "public",             :limit => 1, :default => 0
    t.integer  "user_id"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "friendships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "accepted_at"
    t.datetime "updated_at"
  end

  create_table "images", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "intervals", :force => true do |t|
    t.integer  "trainingsession_id"
    t.integer  "user_id"
    t.integer  "position"
    t.string   "dist_or_dur"
    t.integer  "rest",                :default => 0
    t.integer  "distance"
    t.string   "distance_units"
    t.integer  "duration_hr"
    t.integer  "duration_min"
    t.integer  "duration_sec"
    t.integer  "duration_point"
    t.integer  "aim_for_rate"
    t.integer  "aim_for_rate_q",      :default => 0
    t.integer  "aim_for_split_min",   :default => 2
    t.integer  "aim_for_split_sec"
    t.integer  "aim_for_split_point"
    t.integer  "aim_for_split_q"
    t.integer  "aim_for_wattage"
    t.integer  "aim_for_wattage_q"
    t.integer  "res_rate"
    t.integer  "res_wattage"
    t.integer  "res_avg_hr"
    t.integer  "res_max_hr"
    t.integer  "res_split_min"
    t.integer  "res_split_sec"
    t.integer  "res_split_point"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "category"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "manufacturer"
    t.text     "amazon_link_tandi"
    t.text     "amazon_link_t"
    t.text     "amazon_link_i"
  end

