describe "#{Restikle::ResourceManager} REST" do
  extend WebStub::SpecHelpers

  URL_FOR_SPECS = 'http://api.tillless.com/api/'

  URL_FOR_GET_STATES_1  = 'http://api.tillless.com/api/states/1'
  JSON_FOR_GET_STATES_1 = BW::JSON.parse <<EOF
{
  "id": 1,
  "name": "Canillo",
  "abbr": "02",
  "country_id": 1
}
EOF

  URL_FOR_GET_COUNTRIES_1  = 'http://api.tillless.com/api/countries/1'
  JSON_FOR_GET_COUNTRIES_1 = BW::JSON.parse <<EOF
{
  "id": 1,
  "iso_name": "ANDORRA",
  "iso": "AD",
  "iso3": "AND",
  "name": "Andorra",
  "numcode": 20,
  "states": [
    {
      "id": 6,
      "name": "Andorra la Vella",
      "abbr": "07",
      "country_id": 1
    },
    {
      "id": 1,
      "name": "Canillo",
      "abbr": "02",
      "country_id": 1
    },
    {
      "id": 2,
      "name": "Encamp",
      "abbr": "03",
      "country_id": 1
    },
    {
      "id": 7,
      "name": "Escaldes-Engordany",
      "abbr": "08",
      "country_id": 1
    },
    {
      "id": 3,
      "name": "La Massana",
      "abbr": "04",
      "country_id": 1
    },
    {
      "id": 4,
      "name": "Ordino",
      "abbr": "05",
      "country_id": 1
    },
    {
      "id": 5,
      "name": "Sant Julià de Lòria",
      "abbr": "06",
      "country_id": 1
    }
  ]
}
EOF

  # Run once at the beginning to set up CDQ before all tests
  describe 'setup CDQ' do
    it 'should setup CDQ' do
      CDQ.cdq.setup
      true.should == true
    end
  end


  # REST specs (separated from CDQ setup / reset)
  describe 'run REST specs' do

    before do
      setup_rest_web_stubs
    end

    after do
      teardown_rest_web_stubs
    end

    def setup_rest_web_stubs
      stub_request(
        :get, URL_FOR_GET_STATES_1).
        to_return(json: JSON_FOR_GET_STATES_1)
      stub_request(
        :get, URL_FOR_GET_COUNTRIES_1).
        to_return(json: JSON_FOR_GET_COUNTRIES_1)
    end

    def teardown_rest_web_stubs
      reset_stubs
    end

    it 'should reset' do
      Restikle::ResourceManager.reset!.should == true
      @rsmgr = nil
    end

    it 'should have URL requests and JSON responses' do
      URL_FOR_GET_STATES_1.should     == 'http://api.tillless.com/api/states/1'
      JSON_FOR_GET_STATES_1.should    != nil
      URL_FOR_GET_COUNTRIES_1.should  == 'http://api.tillless.com/api/countries/1'
      JSON_FOR_GET_COUNTRIES_1.should != nil
    end

    it 'should have the api_url set to something sensible' do
      api_url = URL_FOR_SPECS

      Restikle::ResourceManager.api_url.should != nil
      Restikle::ResourceManager.set_api_url api_url
      Restikle::ResourceManager.api_url.should == api_url
    end

    it 'should exist and be setup' do
      @rsmgr = Restikle::ResourceManager.setup
      @rsmgr.should != nil

      Restikle::ResourceManager.instrumentor.should != nil

      Restikle::ResourceManager.load_schema(
        file: 'schema_rails.rb', remove_from_entities: 'spree_')
        .should == true
      Restikle::ResourceManager.entities.size.should > 0

      Restikle::ResourceManager.load_routes(
        file: 'tillless-commerce-api-routes.txt', remove_from_paths: '/api/')
        .should == true
      Restikle::ResourceManager.routes.size.should > 0

      Restikle::ResourceManager.relationships.should != nil
    end

    it 'should build RestKit mappings from routes, entities and relationships' do
      @rsmgr.should != nil

      Restikle::ResourceManager.build_mappings
        .should == true
    end

    # it 'should dump out its config' do
    #   puts ' '
    #   Restikle::ResourceManager.instrumentor.dump_paths_for_entities
    #   puts ' '
    #   true.should == true
    # end

    it 'should allow a simple (non-nested) get call to the back-end (states/1)' do
      @rsmgr.should != nil

      @status = :unknown
      @state = State.where(:id).eq(1).first
      Dispatch::Queue.concurrent(:default).async do
        @rsmgr.manager.getObject(
          @state,
          path: 'states/1',
          parameters: nil,
          success: ->(op,res) {
            puts  "\n  - op: #{op}"
            print  "  - res: #{res}"
            cdq.save
            @status = :success
            resume
          },
          failure: ->(op,err) {
            puts  "\n  - op: #{op}"
            print  "  - err: #{err}"
            @status = :failed
            resume
          }
        )
      end

      wait_max 20.0 do
        @status.should != :failed
        @status.should != :unknown
        @status.should == :success

        @state = State.where(:id).eq(1).first
        @state.should != nil
        @state.id.should == 1
        # puts "@state: #{@state.inspect}"
      end
    end

    it 'should allow a not-so-simple (nested) get call to the back-end (countries/1)' do
      @rsmgr.should != nil

      @status = :unknown
      @country = Country.where(:id).eq(1).first
      Dispatch::Queue.concurrent(:default).async do
        @rsmgr.manager.getObject(
          @country,
          path: 'countries/1',
          parameters: nil,
          success: ->(op,res) {
            puts  "\n  - op: #{op}"
            print  "  - res: #{res}"
            cdq.save
            @status = :success
            resume
          },
          failure: ->(op,err) {
            puts  "\n  - op: #{op}"
            print  "  - err: #{err}"
            @status = :failed
            resume
          }
        )
      end

      wait_max 20.0 do
        @status.should != :failed
        @status.should != :unknown
        @status.should == :success

        @country = Country.where(:id).eq(1).first
        @country.should != nil
        @country.id.should == 1
        # puts "@country: #{@country.inspect}"
      end
    end
  end


  # Tear down CDQ after all REST tests
  describe 'reset CDQ' do
    it 'should reset CDQ' do
      CDQ.cdq.reset!
      true.should == true
    end
  end
end
