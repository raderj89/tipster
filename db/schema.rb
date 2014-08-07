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

ActiveRecord::Schema.define(version: 20140807162809) do

  create_table "admins", force: true do |t|
    t.string   "email",           null: false
    t.string   "password_digest", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employees", force: true do |t|
    t.string   "first_name",                          null: false
    t.string   "last_name",                           null: false
    t.string   "email",                               null: false
    t.string   "password_digest",                     null: false
    t.integer  "tip_average"
    t.boolean  "is_admin",            default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "invitation_id",                       null: false
    t.string   "nickname"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "log_in_count",        default: 0
  end

  add_index "employees", ["email"], name: "index_employees_on_email", unique: true, using: :btree
  add_index "employees", ["invitation_id"], name: "index_employees_on_invitation_id", using: :btree

  create_table "invitations", force: true do |t|
    t.string   "recipient_email",                  null: false
    t.string   "token",                            null: false
    t.integer  "sender_id",                        null: false
    t.string   "sender_type",                      null: false
    t.string   "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_admin",         default: false
    t.string   "property_name"
    t.string   "property_address"
    t.string   "property_city"
    t.string   "property_state"
    t.string   "property_zip"
  end

  add_index "invitations", ["recipient_email"], name: "index_invitations_on_recipient_email", using: :btree

  create_table "properties", force: true do |t|
    t.string   "name"
    t.string   "address",              null: false
    t.string   "city",                 null: false
    t.string   "state",                null: false
    t.string   "zip",                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
  end

  create_table "property_employees", force: true do |t|
    t.integer  "employee_id", null: false
    t.integer  "property_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "title_id"
  end

  add_index "property_employees", ["employee_id"], name: "index_property_employees_on_employee_id", using: :btree
  add_index "property_employees", ["property_id"], name: "index_property_employees_on_property_id", using: :btree

  create_table "titles", force: true do |t|
    t.string   "title",         null: false
    t.integer  "suggested_tip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
