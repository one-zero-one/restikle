describe Restikle::Route do
  before do
    @rails_routes_string = <<-END
    |                     api_promotion GET    /api/promotions/:id(.:format)                                               spree/api/promotions#show {:format=>"json"}
    |                api_product_images GET    /api/products/:product_id/images(.:format)                                  spree/api/images#index {:format=>"json"}
    |                                   POST   /api/products/:product_id/images(.:format)                                  spree/api/images#create {:format=>"json"}
    |             new_api_product_image GET    /api/products/:product_id/images/new(.:format)                              spree/api/images#new {:format=>"json"}
    |            edit_api_product_image GET    /api/products/:product_id/images/:id/edit(.:format)                         spree/api/images#edit {:format=>"json"}
    |                 api_product_image GET    /api/products/:product_id/images/:id(.:format)                              spree/api/images#show {:format=>"json"}
    |                                   PATCH  /api/products/:product_id/images/:id(.:format)                              spree/api/images#update {:format=>"json"}
    |                                   PUT    /api/products/:product_id/images/:id(.:format)                              spree/api/images#update {:format=>"json"}
    |                                   DELETE /api/products/:product_id/images/:id(.:format)                              spree/api/images#destroy {:format=>"json"}
    |              api_product_variants GET    /api/products/:product_id/variants(.:format)                                spree/api/variants#index {:format=>"json"}
    |                                   POST   /api/products/:product_id/variants(.:format)                                spree/api/variants#create {:format=>"json"}
    |           new_api_product_variant GET    /api/products/:product_id/variants/new(.:format)                            spree/api/variants#new {:format=>"json"}
    |          edit_api_product_variant GET    /api/products/:product_id/variants/:id/edit(.:format)                       spree/api/variants#edit {:format=>"json"}
    |               api_product_variant GET    /api/products/:product_id/variants/:id(.:format)                            spree/api/variants#show {:format=>"json"}
    |                                   PATCH  /api/products/:product_id/variants/:id(.:format)                            spree/api/variants#update {:format=>"json"}
    |                                   PUT    /api/products/:product_id/variants/:id(.:format)                            spree/api/variants#update {:format=>"json"}
    |                                   DELETE /api/products/:product_id/variants/:id(.:format)                            spree/api/variants#destroy {:format=>"json"}
    |    api_product_product_properties GET    /api/products/:product_id/product_properties(.:format)                      spree/api/product_properties#index {:format=>"json"}
    |                                   POST   /api/products/:product_id/product_properties(.:format)                      spree/api/product_properties#create {:format=>"json"}
    |  new_api_product_product_property GET    /api/products/:product_id/product_properties/new(.:format)                  spree/api/product_properties#new {:format=>"json"}
    | edit_api_product_product_property GET    /api/products/:product_id/product_properties/:id/edit(.:format)             spree/api/product_properties#edit {:format=>"json"}
    |      api_product_product_property GET    /api/products/:product_id/product_properties/:id(.:format)                  spree/api/product_properties#show {:format=>"json"}
    |                                   PATCH  /api/products/:product_id/product_properties/:id(.:format)                  spree/api/product_properties#update {:format=>"json"}
    |                                   PUT    /api/products/:product_id/product_properties/:id(.:format)                  spree/api/product_properties#update {:format=>"json"}
    |                                   DELETE /api/products/:product_id/product_properties/:id(.:format)                  spree/api/product_properties#destroy {:format=>"json"}
    |                      api_products GET    /api/products(.:format)                                                     spree/api/products#index {:format=>"json"}
    |                                   POST   /api/products(.:format)                                                     spree/api/products#create {:format=>"json"}
    |                   new_api_product GET    /api/products/new(.:format)                                                 spree/api/products#new {:format=>"json"}
    |                  edit_api_product GET    /api/products/:id/edit(.:format)                                            spree/api/products#edit {:format=>"json"}
    |                       api_product GET    /api/products/:id(.:format)                                                 spree/api/products#show {:format=>"json"}
    |                                   PATCH  /api/products/:id(.:format)                                                 spree/api/products#update {:format=>"json"}
    |                                   PUT    /api/products/:id(.:format)                                                 spree/api/products#update {:format=>"json"}
    |                                   DELETE /api/products/:id(.:format)                                                 spree/api/products#destroy {:format=>"json"}
    END
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
      args[:line] = line
      route = Restikle::Route.new(args)
      route.valid?.should == true
      route.path.index(args[:remove_from_paths]).should == nil
    end
  end

end
