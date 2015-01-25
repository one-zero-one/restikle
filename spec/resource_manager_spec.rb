describe Restikle::ResourceManager do
  extend WebStub::SpecHelpers

  before do
    CDQ.cdq.setup
  end

  after do
    CDQ.cdq.reset!
  end

  it "should exist" do
    rsmgr = Restikle::ResourceManager
    rsmgr.should != nil
  end

  it 'should reset' do
    Restikle::ResourceManager.reset!.should == true
    @rsmgr = nil
  end

  it 'should create an Instrumentor if one is not provided' do
    @rsmgr = Restikle::ResourceManager.setup
    @rsmgr.should != nil
    @rsmgr.instrumentor.should != nil
  end

  it 'should allow for configuration of API keys' do
    @rsmgr.should != nil
    @rsmgr.add_headers('X-Spree-Token' => '5b7ee7b72bb606a354b9c5dc2dfc01ee510ed7c272502050')
    @rsmgr.headers['X-Spree-Token'].should != nil
  end

  it 'should allow for the API url to be set' do
    api_url = 'http://localhost:3200/api/'

    # NOTE: set_api_url will call ResourceManager#reset!, which will
    # bork any existing instrumentor that is set up (because of the
    # relationship between the Instrumentor and RestKit).
    @rsmgr.should != nil
    @rsmgr.api_url.should != nil
    @rsmgr.set_api_url api_url
    @rsmgr.api_url.should == api_url
  end

  it 'should work with the Instrumentor' do
    Restikle::ResourceManager.reset!.should == true
    @instr = nil
    @rsmgr = nil

    @instr = Restikle::Instrumentor.new
    @instr.load_schema(file: 'schema_rails.rb',                  remove_from_entities: 'spree_')
    @instr.load_routes(file: 'tillless-commerce-api-routes.txt', remove_from_paths:    '/api/')
    @instr.should != nil

    @rsmgr = Restikle::ResourceManager.setup(@instr)
    @rsmgr.should != nil

    @rsmgr.instrumentor.should == @instr
    @instr.should == @rsmgr.instrumentor

    Restikle::ResourceManager.instrumentor.should == @instr
    @instr.should == Restikle::ResourceManager.instrumentor

    Restikle::ResourceManager.instrumentor.should == @rsmgr.instrumentor
    @rsmgr.instrumentor.should == Restikle::ResourceManager.instrumentor
  end

  it 'should find all entities that exist in both CDQ model and Restikle::Instrumentor' do
    @instr.should != nil
    @rsmgr.should != nil

    all_entities = CDQ.cdq.models.current.entities
    all_entities.each do |cdq_entity|
      matched = false
      @instr.entities.each do |inst_entity|
        matched = true if cdq_entity.name == inst_entity.entity_name
      end
      puts "Looked for: #{cdq_entity.name} ... was not found!" unless matched
      matched.should == true
    end
  end

  it 'should be able to infer relationships from routes and entities' do
    @instr.should != nil
    @rsmgr.should != nil

    @instr.should == Restikle::ResourceManager.instrumentor
    routes   = @rsmgr.routes
    entities = @rsmgr.entities
    routes.should   == Restikle::ResourceManager.instrumentor.routes
    entities.should == Restikle::ResourceManager.instrumentor.entities
    routes.size.should   >= 0
    entities.size.should >= 0
    relationships = @rsmgr.relationships
    relationships.should != nil
    relationships.size.should >= 0

    cached_relationships = @rsmgr.relationships
    relationships.should == cached_relationships

    # puts " "
    # puts "relationships: #{relationships}"
  end
end
