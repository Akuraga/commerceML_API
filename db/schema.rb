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

ActiveRecord::Schema.define(version: 20160714082943) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "banks", force: :cascade do |t|
    t.integer  "payment_account_id"
    t.boolean  "corespondent_bank"
    t.string   "name"
    t.string   "correspondent_account"
    t.string   "bik"
    t.string   "address"
    t.string   "post_index"
    t.string   "country"
    t.string   "region"
    t.string   "area"
    t.string   "city"
    t.string   "street"
    t.string   "build"
    t.string   "housing"
    t.string   "flat"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "catalogs", force: :cascade do |t|
    t.string   "id_xml"
    t.string   "name"
    t.string   "only_change"
    t.integer  "owner_id"
    t.integer  "classifier_id"
    t.integer  "commerce_information_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "classifiers", force: :cascade do |t|
    t.string   "id_xml"
    t.string   "name"
    t.string   "only_change"
    t.integer  "owner_id"
    t.integer  "commerce_information_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "commerce_informations", force: :cascade do |t|
    t.string   "name_document"
    t.string   "version"
    t.string   "date"
    t.boolean  "from_erp"
    t.boolean  "from_site"
    t.boolean  "to_erp"
    t.boolean  "to_site"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "contact_type"
    t.string   "value"
    t.string   "comment"
    t.integer  "contactable_id"
    t.string   "contactable_type"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "contractors", force: :cascade do |t|
    t.string   "id_xml"
    t.string   "name"
    t.string   "role"
    t.integer  "personable_id"
    t.string   "personable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "contractors_documents", id: false, force: :cascade do |t|
    t.integer "contractor_id"
    t.integer "document_id"
  end

  create_table "discounts", force: :cascade do |t|
    t.string   "name"
    t.string   "sum"
    t.string   "percent"
    t.string   "in_total"
    t.integer  "product_id"
    t.integer  "document_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "document_requisites", force: :cascade do |t|
    t.integer  "document_id"
    t.integer  "requisite_id"
    t.string   "value"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "documents", force: :cascade do |t|
    t.string   "id_xml"
    t.string   "number"
    t.string   "date"
    t.string   "economic_op"
    t.string   "role"
    t.string   "currency"
    t.string   "course"
    t.string   "sum"
    t.string   "time"
    t.string   "payment_term"
    t.string   "comment"
    t.integer  "commerce_information_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "documents_products", force: :cascade do |t|
    t.integer  "document_id"
    t.integer  "product_id"
    t.string   "price"
    t.string   "quantity"
    t.string   "sum"
    t.string   "unit"
    t.string   "coefficient"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "documents_tax_values", force: :cascade do |t|
    t.integer  "document_id"
    t.integer  "tax_id"
    t.string   "in_total"
    t.string   "sum"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string   "id_xml"
    t.string   "name"
    t.integer  "classifier_id"
    t.integer  "groupable_id"
    t.string   "groupable_type"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "groups_products", id: false, force: :cascade do |t|
    t.integer "group_id"
    t.integer "product_id"
  end

  create_table "handbooks", force: :cascade do |t|
    t.string   "id_xml"
    t.string   "value"
    t.integer  "property_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "handbooks_products", id: false, force: :cascade do |t|
    t.integer "handbook_id"
    t.integer "product_id"
  end

  create_table "identity_cards", force: :cascade do |t|
    t.string   "type_document"
    t.string   "series"
    t.string   "number"
    t.string   "issue_date"
    t.string   "issued_by"
    t.integer  "physical_persone_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "legal_entities", force: :cascade do |t|
    t.string   "official_name"
    t.string   "inn"
    t.string   "kpp"
    t.string   "egrpo"
    t.string   "okpo"
    t.string   "address"
    t.string   "post_index"
    t.string   "country"
    t.string   "region"
    t.string   "area"
    t.string   "city"
    t.string   "street"
    t.string   "build"
    t.string   "housing"
    t.string   "flat"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "magento2_catalog_products", force: :cascade do |t|
    t.string   "sku"
    t.string   "store_view_code"
    t.string   "attribute_set_code"
    t.string   "product_type"
    t.string   "categories"
    t.string   "product_websites"
    t.string   "name"
    t.string   "description"
    t.string   "short_description"
    t.string   "weight"
    t.string   "product_online"
    t.string   "tax_class_name"
    t.string   "visibility"
    t.string   "price"
    t.string   "special_price"
    t.string   "special_price_from_date"
    t.string   "special_price_to_date"
    t.string   "url_key"
    t.string   "meta_title"
    t.string   "meta_keywords"
    t.string   "meta_description"
    t.string   "base_image"
    t.string   "base_image_label"
    t.string   "small_image"
    t.string   "small_image_label"
    t.string   "thumbnail_image"
    t.string   "thumbnail_image_label"
    t.string   "swatch_image"
    t.string   "swatch_image_label"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "new_from_date"
    t.string   "new_to_date"
    t.string   "display_product_options_in"
    t.string   "map_price"
    t.string   "msrp_price"
    t.string   "map_enabled"
    t.string   "gift_message_available"
    t.string   "custom_design"
    t.string   "custom_design_from"
    t.string   "custom_design_to"
    t.string   "custom_layout_update"
    t.string   "page_layout"
    t.string   "product_options_container"
    t.string   "msrp_display_actual_price_type"
    t.string   "country_of_manufacture"
    t.string   "additional_attributes"
    t.string   "qty"
    t.string   "out_of_stock_qty"
    t.string   "use_config_min_qty"
    t.string   "is_qty_decimal"
    t.string   "allow_backorders"
    t.string   "use_config_backorders"
    t.string   "min_cart_qty"
    t.string   "use_config_min_sale_qty"
    t.string   "max_cart_qty"
    t.string   "use_config_max_sale_qty"
    t.string   "is_in_stock"
    t.string   "notify_on_stock_below"
    t.string   "use_config_notify_stock_qty"
    t.string   "manage_stock"
    t.string   "use_config_manage_stock"
    t.string   "use_config_qty_increments"
    t.string   "qty_increments"
    t.string   "use_config_enable_qty_inc"
    t.string   "enable_qty_increments"
    t.string   "is_decimal_divided"
    t.string   "website_id"
    t.string   "related_skus"
    t.string   "crosssell_skus"
    t.string   "upsell_skus"
    t.string   "additional_images"
    t.string   "additional_image_labels"
    t.string   "hide_from_product_page"
    t.string   "custom_options"
    t.string   "bundle_price_type"
    t.string   "bundle_sku_type"
    t.string   "bundle_price_view"
    t.string   "bundle_weight_type"
    t.string   "bundle_values"
    t.string   "associated_skus"
  end

  create_table "magento2_customers", force: :cascade do |t|
    t.string   "id_csv"
    t.string   "name"
    t.string   "email"
    t.string   "group"
    t.string   "phone"
    t.string   "zip"
    t.string   "country"
    t.string   "state"
    t.string   "customer_since"
    t.string   "web_site"
    t.string   "last_logged_in"
    t.string   "confirmed_email"
    t.string   "account_created_in"
    t.string   "billing_address"
    t.string   "shipping_address"
    t.string   "date_of_birth"
    t.string   "tax_vat_number"
    t.string   "gender"
    t.string   "street_address"
    t.string   "city"
    t.string   "fax"
    t.string   "vat_number"
    t.string   "company"
    t.string   "billing_firstname"
    t.string   "billing_lastname"
    t.string   "action"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "magento2_orders", force: :cascade do |t|
    t.string   "id_csv"
    t.string   "purchase_point"
    t.string   "purchase_date"
    t.string   "bill_name"
    t.string   "ship_name"
    t.string   "grand_total_base"
    t.string   "grand_total_purchased"
    t.string   "status"
    t.string   "billing_address"
    t.string   "shipping_address"
    t.string   "shipping_information"
    t.string   "customer_email"
    t.string   "customer_group"
    t.string   "subtotal"
    t.string   "shipping_handling"
    t.string   "customer_name"
    t.string   "payment_method"
    t.string   "total_refunded"
    t.string   "action"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "offers", force: :cascade do |t|
    t.string   "only_change"
    t.string   "id_xml"
    t.string   "name"
    t.integer  "classifier_id"
    t.integer  "catalog_id"
    t.integer  "owner_id"
    t.integer  "commerce_information_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "order_tax_values", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "tax_id"
    t.string   "in_total"
    t.string   "sum"
    t.string   "rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "owners", force: :cascade do |t|
    t.string   "id_xml"
    t.string   "name"
    t.string   "official_name"
    t.string   "name_type"
    t.string   "comment"
    t.string   "address"
    t.string   "post_index"
    t.string   "country"
    t.string   "region"
    t.string   "area"
    t.string   "city"
    t.string   "street"
    t.string   "build"
    t.string   "housing"
    t.string   "flat"
    t.string   "inn"
    t.string   "kpp"
    t.string   "okpo"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "payment_accounts", force: :cascade do |t|
    t.string   "payment_account"
    t.integer  "owner_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "physical_persones", force: :cascade do |t|
    t.string   "full_name"
    t.string   "appeal"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "patronymic"
    t.string   "date_birth"
    t.string   "inn"
    t.string   "kpp"
    t.string   "address"
    t.string   "post_index"
    t.string   "country"
    t.string   "region"
    t.string   "area"
    t.string   "city"
    t.string   "street"
    t.string   "build"
    t.string   "housing"
    t.string   "flat"
    t.integer  "identity_card_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "price_type_tax_values", force: :cascade do |t|
    t.integer  "price_type_id"
    t.integer  "tax_id"
    t.string   "value"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "price_types", force: :cascade do |t|
    t.string   "id_xml"
    t.string   "name"
    t.string   "currency"
    t.integer  "offer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prices", force: :cascade do |t|
    t.string   "presentation"
    t.string   "price"
    t.string   "coefficient"
    t.string   "currency"
    t.string   "unit"
    t.integer  "proposal_id"
    t.integer  "price_type_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "product_attribute_values", force: :cascade do |t|
    t.integer  "product_attribute_id"
    t.integer  "product_id"
    t.string   "value"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "product_attributes", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_attributes_products", id: false, force: :cascade do |t|
    t.integer "product_attribute_id"
    t.integer "product_id"
  end

  create_table "product_images", force: :cascade do |t|
    t.string   "link_image"
    t.integer  "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_properties", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "property_id"
    t.string   "value"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "product_requisites", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "requisite_id"
    t.string   "value"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "product_tax_values", force: :cascade do |t|
    t.integer "product_id"
    t.integer "tax_id"
    t.string  "value"
  end

  create_table "products", force: :cascade do |t|
    t.string   "id_xml"
    t.string   "barcode"
    t.string   "vendorcode"
    t.string   "name"
    t.integer  "catalog_id"
    t.integer  "unit_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "properties", force: :cascade do |t|
    t.integer  "classifier_id"
    t.string   "id_xml"
    t.string   "name"
    t.string   "value"
    t.string   "for_product"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "proposals", force: :cascade do |t|
    t.integer  "product_id"
    t.string   "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "proposals_storages", force: :cascade do |t|
    t.string   "quantity"
    t.integer  "proposal_id"
    t.integer  "storage_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "representatives", force: :cascade do |t|
    t.string   "id_xml"
    t.string   "name"
    t.string   "relation"
    t.string   "address"
    t.string   "post_index"
    t.string   "country"
    t.string   "region"
    t.string   "area"
    t.string   "city"
    t.string   "street"
    t.string   "build"
    t.string   "housing"
    t.string   "flat"
    t.integer  "contractor_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "requisites", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "storages", force: :cascade do |t|
    t.string   "id_xml"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taxes", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "units", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.string   "full_name"
    t.string   "intern_cut"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
