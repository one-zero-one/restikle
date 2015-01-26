module Restikle
  # Platform agnostic processing that can read Rails schema and routes files
  # and infer resources and relationships necessary to talk to a Rails back-end
  # from a client front-end.
  class Generator
    attr_accessor :routes, :remove_from_paths, :entities, :remove_from_entities

    # Create a new Generator
    def self.new(args={})
      super(args).tap do |i|
        i.remove_from_paths    = args[:remove_from_paths]
        i.remove_from_entities = args[:remove_from_entities]
        i.entities = []
        i.routes   = []
      end
    end

    # Reset the generator back to unused state.
    def reset!
      @entities = []
      @routes = []
      @relationships = nil
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
        data = turn_file_into_data_using_platform_specific_method(routes_file)
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
        data = turn_file_into_data_using_platform_specific_method(schema_file)
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

    # Depending on whether or not the app is running as standard Ruby,
    # or inside RubyMotion, then load the file using the appropriate
    # platform mechanism. Override in base class if a platform specific
    # file mechanism is needed. See: Restikle::Instrumentor
    def turn_file_into_data_using_platform_specific_method(file)
      File.open("path-to-file.tar.gz", "rb").read
    end

    # Return an array of related entities for entity name. Result is an array of
    # entity names, and assumes that nested entities are named according to usual
    # Rails convention such that a resource of the form `entities/related_entities/:id`
    # would imply a property of `related_entity_id` in entity `Entity`.
    def related_entities_for(entity_name)
      relationships[entity_name] || []
    end

    # Return the set of relationships currently implied by the relatonship between known
    # routes and entities. Assume that entities are the source of truth, then try to find
    # any routes that reference those entities, and then define a relationship for each
    # #related_resource in each #route that matches a known #entity.
    def relationships
      @relationships ||= Hash.new.tap do |relns|
        @entities.each do |entity|
          @routes.each do |route|
            if route.root_resource == entity.entity_name && route.related_resources.size > 0
              if relns[route.root_resource]
                relns[route.root_resource] += route.related_resources
              else
                relns[route.root_resource] = route.related_resources
              end
            end
          end
        end
        relns.values.each &:uniq!
      end
    end

    # Dump out the paths registred in @routes for each of the @entities
    def dump_paths_for_entities
      @entities.each do |entity|
        puts entity.entity_name
        @routes.each do |route|
          if route.path.index(entity.entity_name.pluralize.underscore)
            puts "  #{route.verb.ljust(7)} #{route.path}"
          end
        end
      end
      nil
    end

  end
end
