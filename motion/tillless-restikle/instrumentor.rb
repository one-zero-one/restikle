module Restikle
  class Instrumentor
    include CDQ
    attr_accessor :routes, :remove_from_paths, :entities, :remove_from_entities

    # Create a new instrumentor
    def self.new(args={})
      super(args).tap do |i|
        i.remove_from_paths    = args[:remove_from_paths]
        i.remove_from_entities = args[:remove_from_entities]
        i.entities = []
        i.routes   = []
      end
    end

    # Parse routes and create an array of Restikle::Route instances, available via #routes
    # If args is a string, assume it is a filename, otherwise:
    #  :data               data to process (as a string)
    #  :file               path to routes file
    #  :remove_from_paths  string to uniformly remove from route paths (eg '/api/1')
    def load_routes(args={})
      if args.instance_of? String
        routes_file = args
      elsif args.instance_of? Hash
        @remove_from_paths = args[:remove_from_paths]
        routes_file        = args[:file]
        routes_data        = args[:data]
      end

      @routes = []
      if routes_file
        path = NSBundle.mainBundle.pathForResource(routes_file, ofType: nil)
        data = NSData.dataWithContentsOfFile(path).to_str
      elsif routes_data
        data = routes_data.to_str
      end

      if data
        data.split(/\n/).each do |line|
          args[:string] = line
          route = Restikle::Route.new(args)
          # Ignore Rails /edit and /new routes
          unless route.special_route?
            route.name = @last_name if route.name.empty?
            @routes << route
            @last_name = route.name
          end
        end
        true
      else
        false
      end
    end

    # Parse schema and create an array of Restikle::Entity instances, available via #entities.
    # If args is a string, assume it is a filename, otherwise:
    #  :data                  data to process (as a string)
    #  :file                  path to schema file
    #  :remove_from_entities  string to uniformly remove from table names
    def load_schema(args={})
      if args.instance_of? String
        schema_file = args
      elsif args.instance_of? Hash
        @remove_from_entities = args[:remove_from_entities]
        schema_file           = args[:file]
        schema_data           = args[:data]
      end

      @entities = []
      if schema_file
        path = NSBundle.mainBundle.pathForResource(schema_file, ofType: nil)
        data = NSData.dataWithContentsOfFile(path).to_str
      elsif schema_data
        data = schema_data.to_str
      end

      if data
        data.split(/\n/).each do |line|
          args[:string] = line
          entity = Restikle::Entity.new(args)
          @entities << entity if entity.entity_name
        end
        true
      else
        false
      end
    end

    def cdq_attributes_for_entity(entity_name)
      out = ""
      attrs = {}
      entity = @entities.find {|e| e.entity_name == entity_name}
      if entity
        cdq_entities = CDQ.cdq.models.current.entities
        cdq_entities.each do |ent|
          out << "\n #{ent.name}"
        end
      end
      out
    end

    # Build a RestKit request and response mapping for each path for entity, where entity_name
    # is known to Restkile following loading of routes and schema files. Response is an array
    # of mappings, with each item: [ { route: {}, request_description: {}, response_descriptor: {} }]
    def restkit_mappings_for(entity_name)
      mappings = []
      entity = @entities.find {|e| e.entity_name == entity_name}
      if entity
        @routes.each do |route|
          if route.path.index(entity.entity_name.underscore)
            mappings << {
              route: route,
              request_descriptor: {
                request_mapping:  RKObjectMapping.requestMapping,
                object_class:     entity.entity_name,
                root_key_path:    route.path,
                method:           rk_request_method_for(route.verb)
              },
              response_descriptor: {
                response_mapping: rk_mapping_for_entity_for_name(entity.entity_name),
                path_pattern:     route.path,
                key_path:         nil,
                method:           rk_request_method_for(route.verb),
                status_codes:     RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)
              }
            }
          end
        end
      end
      mappings
    end

    def rk_mapping_for_entity_for_name(entity_name)
      RKEntityMapping.mappingForEntityForName(entity_name, inManagedObjectStore: store).tap do |m|
        m.addAttributeMappingsFromArray(attributes_for_entity(entity_name))
      end
    end

    def attributes_for_entity(entity_name)
      attrs  = []
      entity = CDQ.cdq.models.current.entities.find {|e| e.name == entity_name}
      entity.attributesByName.each { |attr| attrs << attr[0] } if entity
      attrs
    end

    def manager
      Restikle::ResourceManager.manager
    end
    def store
      Restikle::ResourceManager.store
    end

    # Dump out the paths registred in @routes for each of the @entities
    def log_paths_for_entities
      @entities.each do |entity|
        NSLog entity.entity_name
        @routes.each do |route|
          if route.path.index(entity.entity_name)
            NSLog "  #{route.verb.ljust(7)} #{route.path}"
          end
        end
      end
      nil
    end

    RK_REQUEST_METHODS = {
      get:      RKRequestMethodGET,
      post:     RKRequestMethodPOST,
      put:      RKRequestMethodPUT,
      delete:   RKRequestMethodDELETE,
      head:     RKRequestMethodHEAD,
      patch:    RKRequestMethodPATCH,
      options:  RKRequestMethodOPTIONS,
      any:      RKRequestMethodAny
    }
    # Return a RestKit constant for a HTTP verb string (or symbol)
    def rk_request_method_for(method)
      RK_REQUEST_METHODS[method.to_s.strip.downcase.to_sym]
    end

    RK_REQUEST_METHOD_STRINGS = {
      RKRequestMethodGET     => 'get',
      RKRequestMethodPOST    => 'post',
      RKRequestMethodPUT     => 'put',
      RKRequestMethodDELETE  => 'delete',
      RKRequestMethodHEAD    => 'head',
      RKRequestMethodPATCH   => 'patch',
      RKRequestMethodOPTIONS => 'options',
      RKRequestMethodAny     => 'any'
    }
    # Return a string versiuon of a RestKit constant for a HTTP verbs
    def rk_request_method_string_for(method)
      RK_REQUEST_METHOD_STRINGS[method]
    end
  end
end
