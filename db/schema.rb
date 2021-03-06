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

ActiveRecord::Schema.define(version: 20140823032300) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "stories", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "closed_at"
    t.integer  "epic_order"
    t.integer  "min_epic_parent_story_epic_order"
    t.boolean  "focus"
  end

  create_table "story_order_positions", force: true do |t|
    t.integer  "story_id"
    t.integer  "story_order_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "story_orders", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "story_stories", force: true do |t|
    t.integer  "parent_story_id"
    t.integer  "child_story_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
