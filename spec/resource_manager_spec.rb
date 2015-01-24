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

  it 'should work with the Instrumentor' do
    @instr = Restikle::Instrumentor.new
    @instr.load_schema(file: 'schema_rails.rb',                  remove_from_entities: 'spree_')
    @instr.load_routes(file: 'tillless-commerce-api-routes.txt', remove_from_paths:    '/api/')
    @instr.should != nil

    @rsmgr = Restikle::ResourceManager.setup(@instr)
    @rsmgr.should != nil
    Restikle::ResourceManager.instrumentor.should == @instr
  end

  it 'should create an Instrumentor if one is not provided' do
    rmgr = Restikle::ResourceManager.setup
    rmgr.should != nil
    rmgr.instrumentor.should != nil
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
end
