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

      def setup(instrumentor=nil)
        # NSLog "Restikle::ResourceManager.setup: #{api_url}"
        RKObjectManager.sharedManager = _manager
        @instrumentor = instrumentor

        # Build mappers from @instrumentor.routes and @instrumentor.entities
        if @instrumentor
          @instrumentor.entities.each do |entity|
            mappings = @instrumentor.restkit_mappings_for(entity.entity_name)
            mappings.each do |mapping|
              # NSLog "Restikle::ResourceManager.setup: #{mapping[:route].verb}:#{mapping[:route].path}"
              _manager.addRequestDescriptor(
                RKRequestDescriptor.requestDescriptorWithMapping(
                  mapping[:request_descriptor][:request_mapping],
                  objectClass: mapping[:request_descriptor][:object_class],
                  rootKeyPath: mapping[:request_descriptor][:root_key_path],
                  method: mapping[:request_descriptor][:method]
                )
              )
              _manager.addResponseDescriptor(
                RKResponseDescriptor.responseDescriptorWithMapping(
                  mapping[:response_descriptor][:response_mapping],
                  method: mapping[:response_descriptor][:method],
                  pathPattern: mapping[:response_descriptor][:path_pattern],
                  keyPath: mapping[:response_descriptor][:key_path],
                  statusCodes: mapping[:response_descriptor][:status_codes]
                )
              )
            end
          end
        else
          NSLog 'Restikle::ResourceManager.setup: no instrumentor is configured, so no RestKit mappings loaded'
        end

        # Configure pagination settings
        _manager.setPaginationMapping(default_pagination_mapping)

        self
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
          @api_url ||= "http://api.tillless.com/api"
        end
        def set_api_url(au)
          @api_url = "#{au}#{au[-1] == '/' ? '' : '/'}"   # add trailing / if it's not there
          reset!
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

        def reset!
          @manager = nil
          @store = nil
          setup @instrumentor
        end

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
