module Restikle
  class ResourceManager
    class << self
      include CDQ

      def instrumentor
        @instrumentor ||= Restikle::Instrumentor.new
      end

      def setup(instr=nil)
        # NSLog "Restikle::ResourceManager.setup: #{api_host}"
        RKObjectManager.sharedManager = _manager
        @instrumentor = instr

        # Configure pagination settings
        _manager.setPaginationMapping(default_pagination_mapping)

        self
      end

      # Parse routes and create an array of Restikle::Route instances, available via #routes
      # If args is a string, assume it is a filename, otherwise:
      #  :data               data to process (as a string)
      #  :file               path to routes file
      #  :remove_from_paths  string to uniformly remove from route paths (eg '/api/1')
      def load_routes(args={})
        instrumentor.load_routes(args)
      end

      # Return routes currently configured in #instrumentor
      def routes
        instrumentor.routes
      end

      # Parse schema and create an array of Restikle::Entity instances, available via #entities.
      # If args is a string, assume it is a filename, otherwise:
      #  :data                  data to process (as a string)
      #  :file                  path to schema file
      #  :remove_from_entities  string to uniformly remove from table names
      def load_schema(args={})
        instrumentor.load_schema(args)
      end

      # Return entities currently configured in #instrumentor
      def entities
        instrumentor.entities
      end

      # Return implied relationships currently configured in #instrumentor
      def relationships
        instrumentor.relationships
      end

      # Use the contents of #routes, #entities and #relationships to assemble a
      # set of RestKit resource mappings.
      def build_mappings
        instrumentor.build_mappings(_manager)
      end

      # Number of RestKit mappings created on last run, or -1 if
      # #build_mappings has not been called.
      def mappings_created
        instrumentor.mappings_created
      end

      def default_pagination_mapping
        @pagination_mapping ||= begin
          @pagination_mapping = RKObjectMapping.mappingForClass(RKPaginator)
          @pagination_mapping.addAttributeMappingsFromDictionary({
            "pagination.per_page"  => "perPage",
            "pagination.pages"     => "pageCount",
            "pagination.count"     => "objectCount",
            "pagination.current"   => "currentPage"
            })
        end
        @pagination_mapping
      end

      def default_pagination_request_string
        'page=:currentPage&per_page=:perPage'
      end

      def pagination_request_string_for_entity(entity)
        "#{entity}?#{default_pagination_request_string}"
      end

      def pagination_request_string_for_entity(entity, with_params: params)
        prstr =  "#{entity}?"
        params.each {|k,v| prstr << "#{k}=#{v}&"}
        prstr << "#{default_pagination_request_string}"
      end

      def api_url
        "#{api_host}#{api_ver}"
      end

      def api_host
        @api_host ||= "http://api.tillless.com/"
      end

      def set_api_host(au)
        @api_host = "#{au}#{au[-1] == '/' ? '' : '/'}"   # add trailing / if it's not there
        reset!
        @api_host
      end

      def api_ver
        @api_ver ||= 'api/'
      end

      def set_api_ver(av)
        @api_ver = "#{av}#{av[-1] == '/' ? '' : '/'}"   # add trailing / if it's not there]
        reset!
        @api_ver
      end

      def manager
        RKObjectManager.sharedManager
      end

      def store
        manager.managedObjectStore
      end

      def headers
        @headers ||= {}
      end

      def add_headers(hh)
        headers.merge!(hh)
        headers.each do |key,val|
          manager.HTTPClient.setDefaultHeader(key, value: val)
        end
      end

      def reset!
        @manager = nil
        @store = nil
        @instrumentor = nil
        true
      end

      private

      def _manager
        @manager ||= RKObjectManager.managerWithBaseURL(NSURL.URLWithString(api_host)).tap do |m|
          m.managedObjectStore = _store
        end
        @manager
      end

      def _store
        @store ||= RKManagedObjectStore.alloc.initWithPersistentStoreCoordinator(cdq.stores.current).tap do |s|
          s.createManagedObjectContexts
          cdq.contexts.push(s.persistentStoreManagedObjectContext)
          cdq.contexts.push(s.mainQueueManagedObjectContext)
        end
        @store
      end
    end
  end
end
