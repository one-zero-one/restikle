describe Restikle::Entity do
  before do
    @rails_schema_string = Restikle::Instrumentor::RAILS_SCHEMA_STRING
    @cdq_schema_string   = Restikle::Instrumentor::CDQ_SCHEMA_STRING
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
