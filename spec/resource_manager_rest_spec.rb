describe "#{Restikle::ResourceManager} REST" do
  extend WebStub::SpecHelpers

  URL_FOR_SPECS = 'http://api.tillless.com/api/'

  URL_FOR_GET_STATES_1  = "#{Restikle::ResourceManager.api_url}/states/1"
  JSON_FOR_GET_STATES_1 = BW::JSON.parse <<EOF
{
  "id": 1,
  "name": "Canillo",
  "abbr": "02",
  "country_id": 1
}
EOF

  URL_FOR_GET_COUNTRIES_1  = "#{Restikle::ResourceManager.api_url}/countries/1"
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

  before do
    CDQ.cdq.setup
    setup_rest_web_stubs
  end

  after do
    CDQ.cdq.reset!
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

  it 'should exist and be setup' do
    @rsmgr = Restikle::ResourceManager.setup
    @rsmgr.should != nil
    Restikle::ResourceManager.instrumentor.should != nil
    Restikle::ResourceManager.load_schema(file: 'schema_rails.rb',                  remove_from_entities: 'spree_')
    Restikle::ResourceManager.load_routes(file: 'tillless-commerce-api-routes.txt', remove_from_paths:    '/api/')
  end

  it 'should have URL requests and JSON responses' do
    URL_FOR_GET_STATES_1.should     == 'http://api.tillless.com/api/states/1'
    JSON_FOR_GET_STATES_1.should    != nil
    URL_FOR_GET_COUNTRIES_1.should  == 'http://api.tillless.com/api/countries/1'
    JSON_FOR_GET_COUNTRIES_1.should != nil
  end

  it 'should have the api_url set to something sensible' do
    api_url = URL_FOR_SPECS
    @rsmgr.should != nil
    @rsmgr.api_url.should != nil
    @rsmgr.set_api_url api_url
    @rsmgr.api_url.should == api_url
  end

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
        puts "\n op: #{op}"
        puts   "res: #{res}"
        cdq.save
        @status = :success
        resume
      },
      failure: ->(op,err) {
        puts "\n op: #{op}"
        puts   "err: #{err}"
        @status = :failed
        resume
      }
      )
    end
    wait_max 20.0 do
      @status.should != :failed
      @status.should != :unknown
      @status.should == :success
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
        puts "\n op: #{op}"
        puts   "res: #{res}"
        cdq.save
        @status = :success
        resume
      },
      failure: ->(op,err) {
        puts "\n op: #{op}"
        puts   "err: #{err}"
        @status = :failed
        resume
      }
      )
    end

    wait_max 20.0 do
      @status.should != :failed
      @status.should != :unknown
      @status.should == :success
    end
  end
end
