module Restikle
  class ResourceManager
    class << self
      include CDQ

      def reset
        @instrumentor = nil
        @manager = nil
        @store = nil
      end

      def instrumentor
        @instrumentor ||= Restikle::Instrumentor.new
      end

      def setup(instrumentor)
        # NSLog "Restikle::ResourceManager.setup: #{api_url}"
        RKObjectManager.sharedManager = _manager
        @instrumentor = instrumentor

        # TODO: Build mappers from @instrumentor.routes and @instrumentor.entities
        # @mappers.each do |mapper|
        #   _manager.addRequestDescriptor(mapper.request_descriptor)
        #   _manager.addResponseDescriptor(mapper.response_descriptor)
        # end
        _manager.setPaginationMapping(default_pagination_mapping)
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
          "#{api_ver}/#{entity}?#{default_pagination_request_string}"
        end
        def pagination_request_string_for_entity(entity, with_params: params)
          prstr =  "#{api_ver}/#{entity}?"
          params.each {|k,v| prstr << "#{k}=#{v}&"}
          prstr << "#{default_pagination_request_string}"
        end

        def api_url
          @api_url ||= "http://api.tillless.com#{api_ver}"
        end
        def set_api_url(au)
          au = "#{au}/" if au[-1] != '/'                      # add trailing / if it's not there
          ve = api_ver[0] == '/' ? api_ver[1..-1] : api_ver   # remove leading / if it is there
          @api_url = "#{au}#{ve}"
        end
        def api_ver
          @api_ver ||= '/api'
        end
        def set_api_ver(av)
          @api_url = nil
          @api_ver = av
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


        private

        def _manager
          @manager ||= RKObjectManager.managerWithBaseURL(NSURL.URLWithString(api_url)).tap do |m|
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
