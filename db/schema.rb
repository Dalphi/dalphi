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

ActiveRecord::Schema.define(version: 20160923141257) do

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "annotation_documents", force: :cascade do |t|
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "raw_datum_id"
    t.integer  "project_id"
    t.text     "payload"
    t.integer  "rank"
    t.boolean  "skipped"
    t.datetime "requested_at"
    t.integer  "interface_type_id"
    t.index ["interface_type_id"], name: "index_annotation_documents_on_interface_type_id"
    t.index ["project_id"], name: "index_annotation_documents_on_project_id"
    t.index ["raw_datum_id"], name: "index_annotation_documents_on_raw_datum_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "interface_types", force: :cascade do |t|
    t.string   "name"
    t.text     "test_payload"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "interface_types_services", id: false, force: :cascade do |t|
    t.integer "interface_type_id", null: false
    t.integer "service_id",        null: false
    t.index ["interface_type_id", "service_id"], name: "index_iface_types_services_on_iface_type_id_and_service_id"
    t.index ["service_id", "interface_type_id"], name: "index_services_iface_types_on_iface_type_id_and_service_id"
  end

  create_table "interfaces", force: :cascade do |t|
    t.string   "title"
    t.text     "associated_problem_identifiers"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.text     "compiled_stylesheet"
    t.text     "compiled_java_script"
    t.string   "template_file_name"
    t.string   "template_content_type"
    t.integer  "template_file_size"
    t.datetime "template_updated_at"
    t.string   "stylesheet_file_name"
    t.string   "stylesheet_content_type"
    t.integer  "stylesheet_file_size"
    t.datetime "stylesheet_updated_at"
    t.string   "java_script_file_name"
    t.string   "java_script_content_type"
    t.integer  "java_script_file_size"
    t.datetime "java_script_updated_at"
    t.integer  "interface_type_id"
    t.index ["interface_type_id"], name: "index_interfaces_on_interface_type_id"
  end

  create_table "interfaces_projects", id: false, force: :cascade do |t|
    t.integer "interface_id", null: false
    t.integer "project_id",   null: false
    t.index ["interface_id", "project_id"], name: "index_interfaces_projects_on_interface_id_and_project_id"
    t.index ["project_id", "interface_id"], name: "index_interfaces_projects_on_project_id_and_interface_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "admin_id"
    t.integer  "iterate_service_id"
    t.integer  "machine_learning_service_id"
    t.integer  "merge_service_id"
    t.index ["admin_id"], name: "index_projects_on_admin_id"
    t.index ["iterate_service_id"], name: "index_projects_on_iterate_service_id"
    t.index ["machine_learning_service_id"], name: "index_projects_on_machine_learning_service_id"
    t.index ["merge_service_id"], name: "index_projects_on_merge_service_id"
  end

  create_table "raw_data", force: :cascade do |t|
    t.string   "shape"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.datetime "data_updated_at"
    t.integer  "project_id"
    t.string   "filename"
    t.index ["project_id"], name: "index_raw_data_on_project_id"
  end

  create_table "services", force: :cascade do |t|
    t.integer  "role"
    t.string   "description"
    t.string   "problem_id"
    t.string   "url"
    t.string   "title"
    t.string   "version"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.text     "interface_types"
  end

  create_table "statistics", force: :cascade do |t|
    t.string   "key"
    t.string   "value"
    t.integer  "iteration_index"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "project_id"
    t.index ["project_id"], name: "index_statistics_on_project_id"
  end

end
