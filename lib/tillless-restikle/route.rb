module Restikle
  class Route
    attr_accessor :name, :verb, :path, :ctrl, :remove_from_paths

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
          r.name, r.verb, r.path, r.ctrl = r.parse_route_string(args[:line]) if args[:line]
        end
      end
    end

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

    # Human readable output
    def to_s
      "#{@name}, #{@verb}, #{@path}, #{@ctrl}"
    end
  end
end
