module Restikle
  class Route
    attr_accessor :name, :verb, :path, :ctrl, :remove_from_paths

    # Create a new route. If args is a string, attempt to parse it into :name, :verb,
    # :path and :ctrl. If args is a hash, :string must be specified as the value to
    # parse. If :remove_from_paths is speciifed, then that string will be removed
    # uniformly from each route path.
    def initialize(args={})
      if args.instance_of? String
        @name, @verb, @path, @ctrl = parse_route_string(args)
      else
        @remove_from_paths = args[:remove_from_paths]
        @name              = args[:name]
        @verb              = args[:verb]
        @path              = args[:path]
        @ctrl              = args[:ctrl]
        @name, @verb, @path, @ctrl = parse_route_string(args[:string]) if args[:string]
      end
    end

    # Extra :name, :verb, :path and :ctrl from str.
    def parse_route_string(str)
      elements = str.split

      # Watch out for partially formed routes. Might be missing '{format='json'}' off
      # the rhs, or might be missing a name if it's a subsequent route for a different
      # verb. If so, add empty items to front and back to ensure that elements.size==5
      case elements.size
      when 3                      # No format string '{format='json'}' OR verb present
        elements << ''
        elements.unshift('')
      when 4                      # No verb present
        elements.unshift('')
      end

      name, verb, path, ctrl = *elements
      name ||= ''
      verb ||= ''
      path ||= ''
      ctrl ||= ''
      path.gsub!(@remove_from_paths, '') if @remove_from_paths
      path.gsub!(/\(\.:format\)/, '')
      [name.strip, verb.strip, path.strip, ctrl.strip]
    end

    # Return the resource name of the root resource of the route. For example, if
    # #path is 'checkouts/:checkout_id/line_items/:id', then #route_resource
    # should be 'Checkout'.
    def root_resource
      return nil unless @path
      if @path =~ /:/
        route_resource = @path.scan(/(\w*)\/:(\w*)/)
        route_resource && route_resource[0] ? route_resource[0][0].singularize.camelize : nil
      else
        @path.singularize.camelize
      end
    end

    # Return an array of resource names for any dependent resources of the resource.
    # For example, if #path is 'checkouts/:checkout_id/line_items/:id', then
    # #related_resources should be ['LineItems']. If #path contains more than one
    # related entity, then the array contains each nested resource in order.
    def related_resources
      return nil unless @path
      related_resources = []
      resources = @path.scan(/(\w*)\/:(\w*)/)
      if resources
        resources.shift
        resources.each do |rsrc|
          related_resources << rsrc[0].singularize.camelize
        end
      end
      related_resources
    end

    # True if the route has valid values for name, verb, path and ctrl
    def valid?
      ! (@name.nil? || @verb.nil? || @path.nil? || @ctrl.nil?)
    end

    # True if the route is for the Rails /edit resource
    def edit_route?
      @path.match /\/edit$/
    end

    # True if the route is for the Rails /new resource
    def new_route?
      @path.match /\/new$/
    end

    # True if the route is for one of the special Rails routes (/new or /edit)
    def special_route?
      @path.match /\/(edit|new)$/
    end

    # Human readable output
    def to_s
      "#{@name}, #{@verb}, #{@path}, #{@ctrl}"
    end

    # For sorting assume that path is the sort variable
    def <=> (other) #1 if self>other; 0 if self==other; -1 if self<other
      @path <=> other.path
    end
  end
end
