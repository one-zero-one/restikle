module Restikle
  class Routes
    attr_accessor :routes

    def self.new(args={})
      super(args).tap do |r|
        if args.instance_of? String
          r.load_routes(args)
        elsif args.instance_of? Hash && args[:routes]
          r.load_routes(args[:routes])
        end
      end
    end

    def load_routes(routes_file)
      @routes = []
      path = NSBundle.mainBundle.pathForResource(routes_file, ofType: nil)
      data = NSData.dataWithContentsOfFile(path).to_str
      data.split(/\n/).each do |line|
        route = Restikle::Route.new(line)
        route.name = @last_name if route.name.empty?
        @routes << route
        @last_name = route.name
      end
    end

  end
end
