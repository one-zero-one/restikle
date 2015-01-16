describe Restikle::Entity do
  before do
    @rails_schema_string = <<-END
    |ActiveRecord::Schema.define(version: 20150111075238) do
    |  create_table "friendly_id_slugs", force: true do |t|
    |    t.string   "slug",                      null: false
    |    t.integer  "sluggable_id",              null: false
    |    t.string   "sluggable_type", limit: 50
    |    t.string   "scope"
    |    t.datetime "created_at"
    |  end
    |  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    |  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    |  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    |  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
    |  create_table "spree_addresses", force: true do |t|
    |    t.string   "firstname"
    |    t.string   "lastname"
    |    t.string   "address1"
    |    t.string   "address2"
    |    t.string   "city"
    |    t.string   "zipcode"
    |    t.string   "phone"
    |    t.string   "state_name"
    |    t.string   "alternative_phone"
    |    t.string   "company"
    |    t.integer  "state_id"
    |    t.integer  "country_id"
    |    t.datetime "created_at"
    |    t.datetime "updated_at"
    |  end
    |  add_index "spree_addresses", ["country_id"], name: "index_spree_addresses_on_country_id"
    |  add_index "spree_addresses", ["firstname"], name: "index_addresses_on_firstname"
    |  add_index "spree_addresses", ["lastname"], name: "index_addresses_on_lastname"
    |  add_index "spree_addresses", ["state_id"], name: "index_spree_addresses_on_state_id"
    |  create_table "spree_adjustments", force: true do |t|
    |    t.integer  "source_id"
    |    t.string   "source_type"
    |    t.integer  "adjustable_id"
    |    t.string   "adjustable_type"
    |    t.decimal  "amount",          precision: 10, scale: 2
    |    t.string   "label"
    |    t.boolean  "mandatory"
    |    t.boolean  "eligible",                                 default: true
    |    t.datetime "created_at"
    |    t.datetime "updated_at"
    |    t.string   "state"
    |    t.integer  "order_id"
    |    t.boolean  "included",                                 default: false
    |  end
    |end
    END

    @cdq_schema_string = <<-END
    | schema "20140611-0001" do
    |   entity "PasswordResetter" do
    |   end
    |   entity "Token" do
    |     string     :authentication_token,  default:  ''
    |     string     :email,                 optional: true
    |     string     :name,                  optional: true
    |     string     :salt,                  optional: true
    |     has_one    :shopper,               optional: true
    |     has_one    :merchant,              optional: true
    |   end
    |   entity "Address" do
    |     datetime   :created_at
    |     datetime   :updated_at
    |     datetime   :deleted_at
    |     string     :street,                default: ''
    |     string     :city,                  default: ''
    |     string     :state,                 default: ''
    |     string     :postcode,              default: ''
    |     string     :country,               default: ''
    |     string     :countrycode,           default: 'AU'
    |   end
    | end
    END
  end

  it "should exist" do
    entity = Restikle::Entity.new
    entity.should != nil
  end

  it 'should use the default matcher unless specified' do
    entity = Restikle::Entity.new('test string')
    entity.entity_matcher.should == Restikle::Entity::DEFAULT_ENTITY_MATCHER
  end

  it 'should be creatable from a string' do
    @rails_schema_string.split(/\n/).each do |line|
      entity = Restikle::Entity.new(line)
      if entity.entity_name
        entity.valid?.should == true
      else
        entity.valid?.should == false
      end
    end
  end

  it 'should be creatable from an args hash' do
    entity = Restikle::Entity.new( rails: true )
    entity.entity_matcher.should == Restikle::Entity::RAILS_SCHEMA_MATCHER
    entity = Restikle::Entity.new( cdq: true )
    entity.entity_matcher.should == Restikle::Entity::CDQ_SCHEMA_MATCHER
  end

  it 'should be createable from an args hash with an :entity_name specified' do
    args   = { entity_name: 'TestEntityName' }
    entity = Restikle::Entity.new(args)
    entity.entity_name.should == args[:entity_name]
    entity.valid?.should == true
  end

  it 'should be createable from an args hash with a :string specified' do
    args   = { string: "  create_table \"spree_adjustments\", force: true do |t|", remove_from_entities: 'spree_' }
    entity = Restikle::Entity.new(args)
    entity.entity_name.should == 'Adjustment'
    entity.valid?.should == true
  end

  it 'should parse a Rails schema file' do
    valid_entities = 0
    @rails_schema_string.split(/\n/).each do |line|
      entity = Restikle::Entity.new(string: line, entity_matcher: Restikle::Entity::RAILS_SCHEMA_MATCHER)
      entity.entity_matcher.should == Restikle::Entity::RAILS_SCHEMA_MATCHER
      if entity.entity_name
        entity.valid?.should == true
        valid_entities += 1
      else
        entity.valid?.should == false
      end
    end
    valid_entities.should == 3
  end

  it 'should parse a CDQ schema file' do
    valid_entities = 0
    @cdq_schema_string.split(/\n/).each do |line|
      entity = Restikle::Entity.new(string: line, entity_matcher: Restikle::Entity::CDQ_SCHEMA_MATCHER)
      entity.entity_matcher.should == Restikle::Entity::CDQ_SCHEMA_MATCHER
      if entity.entity_name
        entity.valid?.should == true
        valid_entities += 1
      else
        entity.valid?.should == false
      end
    end
    valid_entities.should == 3
  end

end
