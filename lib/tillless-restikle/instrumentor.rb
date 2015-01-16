module Restikle
  class Instrumentor
    attr_accessor :routes, :remove_from_paths, :entities, :remove_from_entities

    # Parse routes_file and create an array of Restikle::Route instances, available via #routes
    # Pass a file name as string, or hash of params as:
    #  :routes             path_to_routes_file
    #  :remove_from_paths  string to uniformly remove from route paths (eg '/api/1')
    def load_routes(args={})
      if args.instance_of? String
        routes_file = args
      elsif args.instance_of? Hash
        @remove_from_paths = args[:remove_from_paths]
        routes_file = args[:routes]
      end

      if routes_file
        @routes = []
        path = NSBundle.mainBundle.pathForResource(routes_file, ofType: nil)
        data = NSData.dataWithContentsOfFile(path).to_str
        data.split(/\n/).each do |line|
          args[:string] = line
          route = Restikle::Route.new(args)
          route.name = @last_name if route.name.empty?
          @routes << route
          @last_name = route.name
        end
        true
      else
        false
      end
    end

    # Parse schema_file and create an array of Restikle::Entity instances, available via #entities
    # Pass a file name as string, or hash of params as:
    #  :schema              path_to_schema_file
    #  :remove_from_entities  string to uniformly remove from table names
    def load_schema(args={})
      if args.instance_of? String
        schema_file = args
      elsif args.instance_of? Hash
        @remove_from_entities = args[:remove_from_entities]
        schema_file = args[:schema]
      end

      if schema_file
        @entities = []
        path = NSBundle.mainBundle.pathForResource(schema_file, ofType: nil)
        data = NSData.dataWithContentsOfFile(path).to_str
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

    # Build a RestKit mapper for entity, where entity is known to Restkile following
    # loading of routes and schema files
    def request_mapper_for(entity_to_map)
      mappings = []
      entity = @entities.find {|e| e.entity_name == entity_to_map}
      if entity
        @routes.each do |route|
          if route.path.index(entity.entity_name)
            mappings << {
              response_mapper: RKObjectMapping.requestMapping,
              object_class:    entity.entity_name,
              root_key_path:   route.path,
              method:          route.verb
            }
          end
        end
      end
      mappings
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

  end
end
