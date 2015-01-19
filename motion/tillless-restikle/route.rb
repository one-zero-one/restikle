module Restikle
  class Route
    attr_accessor :name, :verb, :path, :ctrl, :remove_from_paths

    # Create a new route. If args is a string, attempt to parse it into :name, :verb,
    # :path and :ctrl. If args is a hash, :string must be specified as the value to
    # parse. If :remove_from_paths is speciifed, then that string will be removed
    # uniformly from each route path.
    def self.new(args={})
      super(args).tap do |r|
        if args.instance_of? String
          r.name, r.verb, r.path, r.ctrl = r.parse_route_string(args)
        else
          r.remove_from_paths = args[:remove_from_paths]
          r.name              = args[:name]
          r.verb              = args[:verb]
          r.path              = args[:path]
          r.ctrl              = args[:ctrl]
          r.name, r.verb, r.path, r.ctrl = r.parse_route_string(args[:string]) if args[:string]
        end
      end
    end

    # Extra :name, :verb, :path and :ctrl from str.
    def parse_route_string(str)
      elements = str.split
      elements.unshift('') if elements.size == 4
      name, verb, path, ctrl = *elements
      name ||= ''
      verb ||= ''
      path ||= ''
      ctrl ||= ''
      path.gsub!(@remove_from_paths, '') if @remove_from_paths
      path.gsub!(/\(\.:format\)/, '')
      [ name.strip, verb.strip, path.strip, ctrl.strip ]
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

    # True if the route is for one of hte special Rails routes (/new or /edit)
    def special_route?
      @path.match /\/(edit|new)$/
    end

    # Human readable output
    def to_s
      "#{@name}, #{@verb}, #{@path}, #{@ctrl}"
    end
  end
end
