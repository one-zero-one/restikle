module Restikle
  # Add in some default values for route and entity files
  class Instrumentor

    RAILS_SCHEMA_STRING = <<-END
    ActiveRecord::Schema.define(version: 20150111075238) do
      create_table "friendly_id_slugs", force: true do |t|
        t.string   "slug",                      null: false
        t.integer  "sluggable_id",              null: false
        t.string   "sluggable_type", limit: 50
        t.string   "scope"
        t.datetime "created_at"
      end
      add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
      add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
      add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
      add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
      create_table "spree_addresses", force: true do |t|
        t.string   "firstname"
        t.string   "lastname"
        t.string   "address1"
        t.string   "address2"
        t.string   "city"
        t.string   "zipcode"
        t.string   "phone"
        t.string   "state_name"
        t.string   "alternative_phone"
        t.string   "company"
        t.integer  "state_id"
        t.integer  "country_id"
        t.datetime "created_at"
        t.datetime "updated_at"
      end
      add_index "spree_addresses", ["country_id"], name: "index_spree_addresses_on_country_id"
      add_index "spree_addresses", ["firstname"], name: "index_addresses_on_firstname"
      add_index "spree_addresses", ["lastname"], name: "index_addresses_on_lastname"
      add_index "spree_addresses", ["state_id"], name: "index_spree_addresses_on_state_id"
      create_table "spree_adjustments", force: true do |t|
        t.integer  "source_id"
        t.string   "source_type"
        t.integer  "adjustable_id"
        t.string   "adjustable_type"
        t.decimal  "amount",          precision: 10, scale: 2
        t.string   "label"
        t.boolean  "mandatory"
        t.boolean  "eligible",                                 default: true
        t.datetime "created_at"
        t.datetime "updated_at"
        t.string   "state"
        t.integer  "order_id"
        t.boolean  "included",                                 default: false
      end
    end
    END
    
    CDQ_SCHEMA_STRING = <<-END
    schema "20140611-0001" do
      entity "PasswordResetter" do
      end
      entity "Token" do
        string     :authentication_token,  default:  ''
        string     :email,                 optional: true
        string     :name,                  optional: true
        string     :salt,                  optional: true
        has_one    :shopper,               optional: true
        has_one    :merchant,              optional: true
      end
      entity "Address" do
        datetime   :created_at
        datetime   :updated_at
        datetime   :deleted_at
        string     :street,                default: ''
        string     :city,                  default: ''
        string     :state,                 default: ''
        string     :postcode,              default: ''
        string     :country,               default: ''
        string     :countrycode,           default: 'AU'
      end
    end
    END

    RAILS_ROUTES_STRING = <<-END
                         api_promotion GET    /api/promotions/:id(.:format)                                               spree/api/promotions#show {:format=>"json"}
                    api_product_images GET    /api/products/:product_id/images(.:format)                                  spree/api/images#index {:format=>"json"}
                                       POST   /api/products/:product_id/images(.:format)                                  spree/api/images#create {:format=>"json"}
                 new_api_product_image GET    /api/products/:product_id/images/new(.:format)                              spree/api/images#new {:format=>"json"}
                edit_api_product_image GET    /api/products/:product_id/images/:id/edit(.:format)                         spree/api/images#edit {:format=>"json"}
                     api_product_image GET    /api/products/:product_id/images/:id(.:format)                              spree/api/images#show {:format=>"json"}
                                       PATCH  /api/products/:product_id/images/:id(.:format)                              spree/api/images#update {:format=>"json"}
                                       PUT    /api/products/:product_id/images/:id(.:format)                              spree/api/images#update {:format=>"json"}
                                       DELETE /api/products/:product_id/images/:id(.:format)                              spree/api/images#destroy {:format=>"json"}
                  api_product_variants GET    /api/products/:product_id/variants(.:format)                                spree/api/variants#index {:format=>"json"}
                                       POST   /api/products/:product_id/variants(.:format)                                spree/api/variants#create {:format=>"json"}
               new_api_product_variant GET    /api/products/:product_id/variants/new(.:format)                            spree/api/variants#new {:format=>"json"}
              edit_api_product_variant GET    /api/products/:product_id/variants/:id/edit(.:format)                       spree/api/variants#edit {:format=>"json"}
                   api_product_variant GET    /api/products/:product_id/variants/:id(.:format)                            spree/api/variants#show {:format=>"json"}
                                       PATCH  /api/products/:product_id/variants/:id(.:format)                            spree/api/variants#update {:format=>"json"}
                                       PUT    /api/products/:product_id/variants/:id(.:format)                            spree/api/variants#update {:format=>"json"}
                                       DELETE /api/products/:product_id/variants/:id(.:format)                            spree/api/variants#destroy {:format=>"json"}
        api_product_product_properties GET    /api/products/:product_id/product_properties(.:format)                      spree/api/product_properties#index {:format=>"json"}
                                       POST   /api/products/:product_id/product_properties(.:format)                      spree/api/product_properties#create {:format=>"json"}
      new_api_product_product_property GET    /api/products/:product_id/product_properties/new(.:format)                  spree/api/product_properties#new {:format=>"json"}
     edit_api_product_product_property GET    /api/products/:product_id/product_properties/:id/edit(.:format)             spree/api/product_properties#edit {:format=>"json"}
          api_product_product_property GET    /api/products/:product_id/product_properties/:id(.:format)                  spree/api/product_properties#show {:format=>"json"}
                                       PATCH  /api/products/:product_id/product_properties/:id(.:format)                  spree/api/product_properties#update {:format=>"json"}
                                       PUT    /api/products/:product_id/product_properties/:id(.:format)                  spree/api/product_properties#update {:format=>"json"}
                                       DELETE /api/products/:product_id/product_properties/:id(.:format)                  spree/api/product_properties#destroy {:format=>"json"}
                          api_products GET    /api/products(.:format)                                                     spree/api/products#index {:format=>"json"}
                                       POST   /api/products(.:format)                                                     spree/api/products#create {:format=>"json"}
                       new_api_product GET    /api/products/new(.:format)                                                 spree/api/products#new {:format=>"json"}
                      edit_api_product GET    /api/products/:id/edit(.:format)                                            spree/api/products#edit {:format=>"json"}
                           api_product GET    /api/products/:id(.:format)                                                 spree/api/products#show {:format=>"json"}
                                       PATCH  /api/products/:id(.:format)                                                 spree/api/products#update {:format=>"json"}
                                       PUT    /api/products/:id(.:format)                                                 spree/api/products#update {:format=>"json"}
                                       DELETE /api/products/:id(.:format)                                                 spree/api/products#destroy {:format=>"json"}
    END
  end
end
