# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_07_23_165821) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "media_trackings", force: :cascade do |t|
    t.string "media_type", null: false
    t.string "resource_type", null: false
    t.bigint "resource_id", null: false
    t.string "access_url", null: false
    t.string "s3_key", null: false
    t.string "status", default: "inprogress", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "storage_type", default: "single", null: false
    t.index ["resource_type", "resource_id", "media_type", "s3_key"], name: "index_unique_resource_on_media_type", unique: true
    t.index ["s3_key"], name: "index_media_trackings_on_s3_key", unique: true
  end

end
