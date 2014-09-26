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

ActiveRecord::Schema.define(version: 20140821142839) do

  create_table "admins", force: true do |t|
    t.string   "email",           null: false
    t.string   "password_digest", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deposit_methods", force: true do |t|
    t.string   "last_four"
    t.boolean  "is_bank",     default: true
    t.integer  "employee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "deposit_methods", ["employee_id"], name: "index_deposit_methods_on_employee_id", using: :btree

  create_table "employee_addresses", force: true do |t|
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.integer  "employee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "employee_addresses", ["employee_id"], name: "index_employee_addresses_on_employee_id", using: :btree

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
    t.string   "stripe_id"
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
    t.integer  "property_id"
  end

  add_index "invitations", ["property_id"], name: "index_invitations_on_property_id", using: :btree
  add_index "invitations", ["recipient_email"], name: "index_invitations_on_recipient_email", using: :btree

  create_table "payment_methods", force: true do |t|
    t.string   "card_type"
    t.string   "last_four"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payment_methods", ["user_id"], name: "index_payment_methods_on_user_id", using: :btree

  create_table "properties", force: true do |t|
    t.string   "name"
    t.string   "address",                              null: false
    t.string   "city",                                 null: false
    t.string   "state",                                null: false
    t.string   "zip",                                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.text     "full_address"
    t.boolean  "is_managed",           default: false
  end

  create_table "property_employees", force: true do |t|
    t.integer  "employee_id",                null: false
    t.integer  "property_id",                null: false
    t.string   "title",         default: "", null: false
    t.integer  "suggested_tip", default: 0,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "property_employees", ["employee_id"], name: "index_property_employees_on_employee_id", using: :btree
  add_index "property_employees", ["property_id"], name: "index_property_employees_on_property_id", using: :btree

  create_table "property_users", force: true do |t|
    t.integer  "user_id"
    t.integer  "property_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "unit"
  end

  create_table "tips", force: true do |t|
    t.integer  "amount"
    t.integer  "transaction_id"
    t.integer  "employee_id"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tips", ["employee_id"], name: "index_tips_on_employee_id", using: :btree
  add_index "tips", ["transaction_id"], name: "index_tips_on_transaction_id", using: :btree

  create_table "transactions", force: true do |t|
    t.integer  "user_id"
    t.integer  "total"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "property_id", null: false
  end

  add_index "transactions", ["property_id"], name: "index_transactions_on_property_id", using: :btree
  add_index "transactions", ["user_id"], name: "index_transactions_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "first_name",           null: false
    t.string   "last_name",            null: false
    t.string   "email",                null: false
    t.string   "password_digest",      null: false
    t.string   "signature"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "stripe_id"
    t.string   "authentication_token"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
