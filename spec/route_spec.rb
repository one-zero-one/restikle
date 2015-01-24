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

  it 'should be able to infer resource relationships from a simple route' do
    args = {
      remove_from_paths: '/api/',
      name:              'api_classifications',
      verb:              'PUT',
      path:              'classifications',
      ctrl:              'spree/api/classifications#update'
    }
    route = Restikle::Route.new(args)
    root_resource     = route.root_resource
    related_resources = route.related_resources

    root_resource.should == 'Classification'
    related_resources.size.should == 0
  end


  it 'should be able to infer resource relationships from a complex route' do
    args = {
      remove_from_paths: '/api/',
      name:              'api_checkout_line_item',
      verb:              'GET',
      path:              'checkouts/:checkout_id/line_items/:id/third/:id/fourth/:fourth_id',
      ctrl:              'spree/api/line_items#show'
    }
    route = Restikle::Route.new(args)
    root_resource     = route.root_resource
    related_resources = route.related_resources

    root_resource.should == 'Checkout'
    related_resources.size.should == 3
    related_resources[0].should == 'LineItem'
    related_resources[1].should == 'Third'
    related_resources[2].should == 'Fourth'
  end

end
