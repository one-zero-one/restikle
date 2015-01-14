module Restikle
  class Instrumentor
    attr_accessor :routes, :remove_from_paths, :entities, :remove_from_tables

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
          route = Restikle::Route.new(line)
          route.name = @last_name if route.name.empty?
          route.path.gsub!(@remove_from_paths, '') if @remove_from_paths
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
    #  :remove_from_tables  string to uniformly remove from table names
    def load_schema(args={})
      if args.instance_of? String
        schema_file = args
      elsif args.instance_of? Hash
        @remove_from_tables = args[:remove_from_tables]
        schema_file = args[:schema]
      end

      if schema_file
        @entities = []
        path = NSBundle.mainBundle.pathForResource(schema_file, ofType: nil)
        data = NSData.dataWithContentsOfFile(path).to_str
        data.split(/\n/).each do |line|
          entity = Restikle::Entity.new(line)
          if entity.table_name
            entity.table_name.gsub!(@remove_from_tables, '') if @remove_from_tables
            @entities << entity
          end
        end
        true
      else
        false
      end
    end

    # Build a RestKit mapper for resource, where resource is known to Restkile following
    # loading of routes and schema files
    def mapper_for(resource)
    end


    def paths_for_entities
      @entities.each do |entity|
        NSLog entity.table_name
        @routes.each do |route|
          if route.path.index(entity.table_name)
            NSLog "  #{route.verb.ljust(7)} #{route.path}"
          end
        end
      end
    end

  end
end
