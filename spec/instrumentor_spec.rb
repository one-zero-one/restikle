describe Restikle::Instrumentor do
  before do
    @rails_routes_string = Restikle::Instrumentor::RAILS_ROUTES_STRING
    @rails_schema_string = Restikle::Instrumentor::RAILS_SCHEMA_STRING
    @cdq_schema_string   = Restikle::Instrumentor::CDQ_SCHEMA_STRING
  end

  it "should exist" do
    entity = Restikle::Instrumentor.new
    entity.should != nil
  end

  it 'should be creatable from an args hash' do
    args = {
      remove_from_paths:    '/api/',
      remove_from_entities: 'spree_'
    }
    instr = Restikle::Instrumentor.new(args)
    instr.remove_from_paths.should    == args[:remove_from_paths]
    instr.remove_from_entities.should == args[:remove_from_entities]
  end

  it 'should process a Rails schema file' do
    instr = Restikle::Instrumentor.new(remove_from_entities: 'spree_')
    instr.load_schema(data: @rails_schema_string)
    instr.entities.should != nil
    instr.entities.size.should > 0
  end

  it 'should process a CDQ schema file' do
    instr = Restikle::Instrumentor.new()
    instr.load_schema(data: @cdq_schema_string, cdq: true)
    instr.entities.should != nil
    instr.entities.size.should > 0
  end

  it 'should process a Rails routes file' do
    instr = Restikle::Instrumentor.new()
    instr.load_routes(data: @rails_routes_string, remove_from_paths: '/api/')
    instr.routes.should != nil
    instr.routes.size.should > 0
  end

  # it 'should provide a RestKit request mapper for a resource' do
  # end
  #
  # it 'should provide a RestKit response mapper for a resource' do
  # end
end
