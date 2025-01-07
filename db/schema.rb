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

ActiveRecord::Schema[8.0].define(version: 2025_01_04_194847) do
  create_table "attribute_terms", force: :cascade do |t|
    t.integer "attribute_id"
    t.string "slug", null: false
    t.string "name", null: false
    t.string "display_name", default: ""
    t.index ["attribute_id"], name: "index_attribute_terms_on_attribute_id"
  end

  create_table "attributes", force: :cascade do |t|
    t.string "slug", null: false
    t.string "name", null: false
  end

  create_table "feeds", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "url"
    t.string "feed_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "supplier_id"
    t.boolean "on_update_update_existing_entries", default: true
    t.boolean "on_update_undelete_deleted_entries", default: false
    t.json "parsed_data_rows"
    t.index ["supplier_id"], name: "index_feeds_on_supplier_id"
  end

  create_table "images", force: :cascade do |t|
    t.integer "product_id", null: false
    t.string "url"
    t.integer "variation_id"
    t.index ["product_id"], name: "index_images_on_product_id"
    t.index ["variation_id"], name: "index_images_on_variation_id"
  end

  create_table "imports", force: :cascade do |t|
    t.string "filename"
    t.string "status", default: "pending"
    t.text "error_message"
    t.json "log_entries"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inventories", force: :cascade do |t|
    t.string "sku"
    t.string "state"
    t.string "title"
    t.string "description"
    t.string "custom_title"
    t.string "custom_description"
    t.string "width"
    t.string "height"
    t.string "depth"
    t.string "weight"
    t.string "price"
    t.json "categories"
    t.json "tags"
    t.json "images"
    t.json "attributes"
    t.integer "quantity_in_stock"
    t.datetime "last_synced_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sku"], name: "index_inventories_on_sku", unique: true
  end

  create_table "mappings", force: :cascade do |t|
    t.integer "feed_id"
    t.string "input_field"
    t.string "output_field"
    t.string "array_separator", default: ","
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "sample_data", default: ""
    t.boolean "enabled", default: false
    t.string "import_method", default: "simple"
    t.text "import_field"
    t.index ["feed_id"], name: "index_mappings_on_feed_id"
  end

  create_table "product_attributes", force: :cascade do |t|
    t.integer "product_id"
    t.integer "attribute_id"
    t.json "term_slugs"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attribute_id"], name: "index_product_attributes_on_attribute_id"
    t.index ["product_id"], name: "index_product_attributes_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.integer "supplier_id", null: false
    t.string "sku", null: false
    t.string "title", default: ""
    t.string "custom_title", default: ""
    t.string "description", default: ""
    t.string "custom_description", default: ""
    t.decimal "price", precision: 10, scale: 2
    t.integer "quantity_in_stock", default: 0, null: false
    t.decimal "shipping_cost", precision: 10, scale: 2
    t.decimal "height", precision: 10, scale: 2
    t.decimal "width", precision: 10, scale: 2
    t.decimal "length", precision: 10, scale: 2
    t.string "size_unit", default: "in"
    t.decimal "weight", precision: 10, scale: 2
    t.string "weight_unit", default: "lb"
    t.string "category1"
    t.string "category2"
    t.string "category3"
    t.integer "return_policy_code_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "state", default: "active"
    t.boolean "needs_sync", default: true
    t.datetime "last_synced_at"
    t.decimal "custom_price", precision: 10, scale: 2
    t.decimal "msrp", precision: 10, scale: 2
    t.text "categories"
    t.index ["return_policy_code_id"], name: "index_products_on_return_policy_code_id"
    t.index ["sku"], name: "index_products_on_sku", unique: true
    t.index ["supplier_id"], name: "index_products_on_supplier_id"
  end

  create_table "return_policy_codes", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "description"
    t.index ["code"], name: "index_return_policy_codes_on_code", unique: true
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "name"
    t.string "slug", default: "", null: false
    t.json "default_values", default: {}, null: false
    t.json "status_rules", default: {}, null: false
    t.text "price_calculation_rule"
    t.string "sku_prefix", default: ""
  end

  create_table "taggings", force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at", precision: nil
    t.string "tenant", limit: 128
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
    t.index ["tagger_type", "tagger_id"], name: "index_taggings_on_tagger_type_and_tagger_id"
    t.index ["tenant"], name: "index_taggings_on_tenant"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "variation_attributes", force: :cascade do |t|
    t.integer "variation_id"
    t.integer "attribute_id"
    t.integer "attribute_term_id"
    t.index ["attribute_id"], name: "index_variation_attributes_on_attribute_id"
    t.index ["attribute_term_id"], name: "index_variation_attributes_on_attribute_term_id"
    t.index ["variation_id"], name: "index_variation_attributes_on_variation_id"
  end

  create_table "variations", force: :cascade do |t|
    t.integer "product_id"
    t.string "regular_price", default: "0.00"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_variations_on_product_id"
  end

  add_foreign_key "images", "products"
  add_foreign_key "products", "suppliers"
  add_foreign_key "taggings", "tags"
end
