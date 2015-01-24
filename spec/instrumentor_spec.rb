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
    instr = Restikle::Instrumentor.new
    instr.load_schema(data: @cdq_schema_string, cdq: true)
    instr.entities.should != nil
    instr.entities.size.should > 0
  end

  it 'should process a Rails routes file' do
    instr = Restikle::Instrumentor.new
    instr.load_routes(data: @rails_routes_string, remove_from_paths: '/api/')
    instr.routes.should != nil
    instr.routes.size.should > 0
  end

  it 'should support mapping of RKRequestMethod contants from strings and symbols' do
    instr = Restikle::Instrumentor.new
    verbs = {
      'get'     => RKRequestMethodGET,
      'post'    => RKRequestMethodPOST,
      'put'     => RKRequestMethodPUT,
      'delete'  => RKRequestMethodDELETE,
      'head'    => RKRequestMethodHEAD,
      'patch'   => RKRequestMethodPATCH,
      'options' => RKRequestMethodOPTIONS,
      'any'     => RKRequestMethodAny
    }
    verbs.keys.each do |verb|
      rkrm = instr.rk_request_method_for(verb.upcase)
      rkrm.should != nil
      rkrm.should == verbs[verb]
    end
    verbs.keys.each do |verb|
      rkrm = instr.rk_request_method_for(verb.downcase)
      rkrm.should != nil
      rkrm.should == verbs[verb]
    end
    verbs.keys.each do |verb|
      rkrm = instr.rk_request_method_for(verb.to_sym)
      rkrm.should != nil
      rkrm.should == verbs[verb]
    end
    verbs.each do |verb, verb_constant|
      rkrmstr = instr.rk_request_method_string_for(verb_constant)
      rkrmstr.should != nil
      rkrmstr.should == verb
    end
  end

  it 'should work with the ResourceManager' do
    @instr = Restikle::Instrumentor.new
    @instr.load_schema(file: 'schema_rails.rb',                  remove_from_entities: 'spree_')
    @instr.load_routes(file: 'tillless-commerce-api-routes.txt', remove_from_paths:    '/api/')
    @instr.should != nil

    @rsmgr = Restikle::ResourceManager.setup(@instr)
    @rsmgr.should != nil
    Restikle::ResourceManager.instrumentor.should == @instr
  end

  it 'should allow for configuration of API keys' do
    @rsmgr.should != nil
    @rsmgr.add_headers('X-Spree-Token' => '5b7ee7b72bb606a354b9c5dc2dfc01ee510ed7c272502050')
    @rsmgr.headers['X-Spree-Token'].should != nil
  end

  it 'should allow for the API url to be set' do
    api_url = 'http://localhost:3200/api/'

    @rsmgr.should != nil
    @rsmgr.api_url.should != nil
    @rsmgr.set_api_url api_url
    @rsmgr.api_url.should == api_url
  end

  it 'should provide RestKit mappings for an entity' do
    @instr.should != nil
    @rsmgr.should != nil

    @instr.entities.each do |entity|
      mappings = @instr.restkit_mappings_for(entity.entity_name)
      mappings.should != nil
      mappings.each do |mapping|
        mapping[:route].should != nil
        mapping[:request_descriptor].should != nil
        mapping[:request_descriptor][:request_mapping].class.should == RKObjectMapping
        mapping[:request_descriptor][:object_class].should          == entity.entity_name
        mapping[:request_descriptor][:root_key_path].should         == mapping[:route].path
        mapping[:request_descriptor][:method].should                == @instr.rk_request_method_for(mapping[:route].verb)
        mapping[:response_descriptor].should != nil
        mapping[:response_descriptor][:response_mapping].should     != nil
        mapping[:response_descriptor][:path_pattern].should         == mapping[:route].path
        mapping[:response_descriptor][:key_path].should             == nil
        mapping[:response_descriptor][:method].should               == @instr.rk_request_method_for(mapping[:route].verb)
        mapping[:response_descriptor][:status_codes].should         == RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)
        # puts  " "
        # puts  "    entity: #{entity}"
        # puts  "   request: #{mapping[:route].verb} #{mapping[:request_descriptor][:root_key_path]}"
        # id_attrs = []
        # mapping[:response_descriptor][:response_mapping].identificationAttributes.each do |attr|
        #   id_attrs << "#{attr.attributeValueClassName}:#{attr.attributeType}"
        # end
        # puts "  id attrs: #{id_attrs}"
        # puts "resp attrs: #{mapping[:response_descriptor][:response_mapping].entity.attributesByName.keys}"
        # puts "  "
      end
    end
  end
end
