module Restikle
  class Entity
    attr_accessor :table_name

    def self.new(args={})
      super(args).tap do |r|
        if args.instance_of? String
          r.table_name = r.parse_schema_string(args)
        else
          r.table_name = args[:table_name]
        end
      end
    end

    def parse_schema_string(str)
      if (match_data = str.match /.*create_table\s\"(.*)\".*/)
        @table_name = match_data[1].strip
      else
        @table_name = nil
      end
    end

    def to_s
      "#{@table_name}"
    end
  end
end
