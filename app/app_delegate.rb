class AppDelegate
  include CDQ

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    # RKlcl_configure_by_name("Restkit", RKlcl_vDebug)
    # RKlcl_configure_by_name("App", RKlcl_vDebug)
    # RKlcl_configure_by_name("RestKit/Network*", RKlcl_vTrace)
    # RKlcl_configure_by_name("RestKit/ObjectMapping", RKlcl_vTrace)

    return true if RUBYMOTION_ENV == 'test'

    cdq.setup
    Dispatch::Queue.concurrent(:default).async do
      handle_restikle_setup
    end
    true
  end

  def handle_restikle_setup
    NSLog " "
    print "Restikle setup:\n"

    print "  using API endpoint: "
    Restikle::ResourceManager.set_api_host 'http://localhost:3200/api'
    Restikle::ResourceManager.setup
    print "#{Restikle::ResourceManager.api_host}\n"

    print "      loading schema: "
    Restikle::ResourceManager.load_schema(file: 'schema_rails.rb', remove_from_entities: 'spree_')
    print "#{Restikle::ResourceManager.entities.size} entities processed\n"

    print "      loading routes: "
    Restikle::ResourceManager.load_routes(file: 'routes_rails.txt', remove_from_paths: '/api/')
    print "#{Restikle::ResourceManager.routes.size} routes processed\n"

    print "   building mappings: "
    Restikle::ResourceManager.build_mappings
    print "#{Restikle::ResourceManager.mappings_created} mappings created\n"
  end
end
