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

ActiveRecord::Schema.define(version: 20141018064805) do

  create_table "excersises", force: true do |t|
    t.integer  "workout_id"
    t.string   "name",          limit: 100
    t.integer  "excersisetype"
    t.float    "diffculty",     limit: 24
    t.integer  "sets"
    t.integer  "reps"
    t.integer  "group"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "excersises", ["workout_id"], name: "index_excersises_on_workout_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "first_name",      limit: 200
    t.string   "last_name",       limit: 200
    t.string   "email",           limit: 200
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workouts", force: true do |t|
    t.integer  "user_id"
    t.string   "name",       limit: 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "workouts", ["user_id"], name: "index_workouts_on_user_id", using: :btree

end
