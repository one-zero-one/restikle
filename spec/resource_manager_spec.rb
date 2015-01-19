describe Restikle::ResourceManager do
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

    all_entities = CDQ.cdq.models.current.entities
    # puts ' '
    all_entities.each do |entity|
      # puts entity.name
    end
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
      puts "Looked for: #{cdq_entity.name} ... Not Found!" unless matched
    end
  end

end
