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

ActiveRecord::Schema.define(version: 20161210195531) do

  create_table "articles", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "author_id"
    t.integer  "rating"
    t.integer  "data_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_articles_on_author_id"
    t.index ["data_id"], name: "index_articles_on_data_id"
  end

  create_table "authors", force: :cascade do |t|
    t.string   "name"
    t.integer  "age"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "article_id"
    t.string   "body"
    t.integer  "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_comments_on_article_id"
  end

  create_table "data", force: :cascade do |t|
    t.datetime "creation_date"
    t.string   "comment"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "rails_api_doc_api_data", force: :cascade do |t|
    t.integer "api_type"
    t.string  "action_type"
    t.string  "api_action"
    t.string  "type"
    t.string  "name"
    t.string  "special"
    t.string  "desc"
    t.text    "nesting"
  end

  create_table "rails_api_doc_api_datum", force: :cascade do |t|
    t.string "api_type"
    t.string "type"
    t.string "name"
    t.string "special"
    t.string "desc"
    t.text   "nesting"
  end

end
