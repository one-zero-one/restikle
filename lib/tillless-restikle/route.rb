module Restikle
  class Route
    attr_accessor :name, :verb, :path, :ctrl

    def self.new(args={})
      super(args).tap do |r|
        if args.instance_of? String
          r.name, r.verb, r.path, r.ctrl = r.parse_route_string(args)
        else
          r.name = args[:name]
          r.verb = args[:verb]
          r.path = args[:path]
          r.ctrl = args[:ctrl]
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
      [ name.strip, verb.strip, path.gsub(/\(\.:format\)/, '').strip, ctrl.strip ]
    end

    def to_s
      "#{@name}, #{@verb}, #{@path}, #{@ctrl}"
    end
  end
end
