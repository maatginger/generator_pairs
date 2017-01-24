ActiveRecord::Schema.define(version: 20170109130004) do
  
  enable_extension "plpgsql"

  create_table "users", force: :cascade do |t|
    t.string   "first_name",  default: "", null: false
    t.string   "last_name",   default: "", null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

end
