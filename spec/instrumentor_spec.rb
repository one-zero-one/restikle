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

  it 'should provide RestKit mappings for an entity' do
    instr = Restikle::Instrumentor.new
    instr.load_schema(data: @rails_schema_string, remove_from_entities: 'spree_')
    instr.load_routes(data: @rails_routes_string, remove_from_paths: '/api/')
    instr.should != nil
    instr.entities.size > 0
    instr.routes.size > 0

    instr.entities.each do |entity|
      mappings = instr.rk_mappings_for(entity.entity_name)
      mappings.should != nil
      mappings.each do |mapping|
        mapping[:route].should != nil
        mapping[:request_descriptor].should != nil
        mapping[:request_descriptor][:request_mapping].class.should == RKObjectMapping
        mapping[:request_descriptor][:object_class].should          == entity.entity_name
        mapping[:request_descriptor][:root_key_path].should         == mapping[:route].path
        mapping[:request_descriptor][:method].should                == instr.rk_request_method_for(mapping[:route].verb)
        mapping[:response_descriptor].should != nil
        mapping[:response_descriptor][:response_mapping].should     != nil
        mapping[:response_descriptor][:path_pattern].should         == mapping[:route].path
        mapping[:response_descriptor][:key_path].should             == nil
        mapping[:response_descriptor][:method].should               == instr.rk_request_method_for(mapping[:route].verb)
        mapping[:response_descriptor][:status_codes].should         == RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)
      end
    end
  end

  it 'should be reset-able' do
    instr = Restikle::Instrumentor.new
    instr.load_schema(data: @rails_schema_string, remove_from_entities: 'spree_')
    instr.load_routes(data: @rails_routes_string, remove_from_paths: '/api/')
    instr.should != nil
    instr.entities.size > 0
    instr.routes.size > 0
    instr.reset!
    instr.entities.size.should == 0
    instr.routes.size.should == 0
  end


  it 'should be able to transform RM reserved words in an attribute mapping hash' do
    reserved_words = {
      'alice'       => 'ALICE',
      'bob'         => 'BOB'
    }
    input_attrs1 = {
      'alice'       => 'alice',
      'bob'         => 'bob',
      'description' => 'description'
    }
    output_attrs1 = {
      'ALICE'       => 'alice',
      'BOB'         => 'bob',
      'description' => 'description'
    }
    input_attrs2 = {
      'alice'       => 'alice',
      'bob'         => 'bob',
      'descrip'     => 'descrip'
    }
    output_attrs2 = {
      'alice'       => 'alice',
      'bob'         => 'bob',
      'description' => 'descrip'
    }
    instr = Restikle::Instrumentor.new

    # Use local reserved word list
    instr.xform_attribute_hash_for_rm_reserved_words(input_attrs1, reserved_words)
    input_attrs1.should == output_attrs1

    # Use default reserved word list: Restikle::Instrumentor::RM_RESERVED_WORDS
    instr.xform_attribute_hash_for_rm_reserved_words(input_attrs2)
    input_attrs2.should == output_attrs2
  end

end
