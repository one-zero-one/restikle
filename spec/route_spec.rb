describe Restikle::Route do
  before do
    @rails_routes_string = Restikle::Instrumentor::RAILS_ROUTES_STRING
  end

  it "should exist" do
    entity = Restikle::Route.new
    entity.should != nil
  end

  it 'should be creatable from a string' do
    @rails_routes_string.split(/\n/).each do |line|
      route = Restikle::Route.new(line)
      route.valid?.should == true
    end
  end

  it 'should be creatable from an args hash' do
    args = {
      remove_from_paths: '/api/',
      name:              'api_products',
      verb:              'GET',
      path:              'products/:id',
      ctrl:              'spree/api/products#show'
    }
    entity = Restikle::Route.new(args)
    entity.remove_from_paths == args[:remove_from_paths]
    entity.name.should       == args[:name]
    entity.verb.should       == args[:verb]
    entity.path.should       == args[:path]
    entity.ctrl.should       == args[:ctrl]
  end

  it 'should remove a string from the path if supplied' do
    args = { remove_from_paths: '/api/' }
    @rails_routes_string.split(/\n/).each do |line|
      args[:string] = line
      route = Restikle::Route.new(args)
      route.valid?.should == true
      route.path.index(args[:remove_from_paths]).should == nil
    end
  end

end
