require 'restikle/version'
require 'fileutils'
require 'active_support/inflector'

module Restikle
  class Parser
    attr_accessor :output, :setup, :remove_from_entities, :type_map, :relationships

    DEFAULT_TYPE_MAP = {
      string:   'string',
      text:     'string',
      integer:  'integer64',
      datetime: 'datetime',
      decimal:  'decimal',
      float:    'float',
      boolean:  'boolean'
    }

    def initialize(args={})
      @type_map = DEFAULT_TYPE_MAP.clone
      @remove_from_entities = args[:remove_from_entities]
      @relationships        = args[:relationships] || []
      setup
    end

    def map_type(typ)
      @type_map[typ]
    end

    def setup
      @current_table = nil
      @entities      = []
      @indent        = 0
      @setup         = true
      @output        = <<EOF
# This file was generated by Restikle: http://github.com/tillless/restikle
EOF
      @matchers = {
        schema_version:    /^.*ActiveRecord::Schema.define\(version:\s?(.*)\).*$/,
        create_table:      /^.*create_table \"(.*)\",.*$/,
        define_string:     /^.*t\.string\s*\"(\w*)\",?(.*)$/,
        define_text:       /^.*t\.text\s*\"(\w*)\",?(.*)$/,
        define_integer:    /^.*t\.integer\s*\"(\w*)\",?(.*)$/,
        define_datetime:   /^.*t\.datetime\s*\"(\w*)\",?(.*)$/,
        define_decimal:    /^.*t\.decimal\s*\"(\w*)\",?(.*)$/,
        define_float:      /^.*t\.float\s*\"(\w*)\",?(.*)$/,
        define_boolean:    /^.*t\.boolean\s*\"(\w*)\",?(.*)$/,
        end:               /^\s*end\s?$/
      }
    end

    def indent
      '  ' * @indent
    end

    def handle_line(line)
      @matchers.each do |symbol, matcher|
        self.send("handle_#{symbol}", line, matcher) if line =~ matcher
      end
    end

    def handle_schema_version(line, matcher)
      version = matcher.match(line)[1]
      @output << "schema \"#{version}\" do\n"
      @indent += 1
    end

    def handle_create_table(line, matcher)
      entity = matcher.match(line)[1]
      entity.gsub!(@remove_from_entities, '') if @remove_from_entities
      entity = entity.singularize.camelize
      @output << "  entity \"#{entity}\" do\n"
      @output << "    integer64  :id, default: -1\n"
      @indent += 1
      @entities << entity
      @current_table = entity
    end

    def handle_define_field(field, line, matcher)
      field_name  = matcher.match(line)[1]
      field_name  = field_name.empty? ? :unknown : field_name.underscore
      field_name.gsub!('description', 'descrip') # NOTE: iOS #description is reserved
      field_parms = matcher.match(line)[2]
      field_parms = field_parms.empty? ? nil : field_parms.strip.squeeze(' ')
      @output << "#{indent}#{field.ljust(10)} :#{field_name}#{field_parms ? ', ' : ''}#{field_parms}\n"
    end

    def handle_define_string(line, matcher)    handle_define_field(map_type(:string),  line, matcher)  end
    def handle_define_text(line, matcher)      handle_define_field(map_type(:string),  line, matcher)  end
    def handle_define_integer(line, matcher)   handle_define_field(map_type(:integer), line, matcher)  end
    def handle_define_datetime(line, matcher)  handle_define_field(map_type(:datetime),line, matcher)  end
    def handle_define_decimal(line, matcher)   handle_define_field(map_type(:decimal), line, matcher)  end
    def handle_define_float(line, matcher)     handle_define_field(map_type(:float),   line, matcher)  end
    def handle_define_boolean(line, matcher)   handle_define_field(map_type(:boolean), line, matcher)  end

    def handle_end(line, matcher)
      if @current_table
        handle_define_has_many_relationships
        handle_define_belongs_to_relationships
        @current_table = nil
      end
      @indent -= 1 unless @indent == 0
      @output << "#{indent}end\n"
    end

    # Is the current table one of the tables that has has_many relationships?
    def handle_define_has_many_relationships
      if @relationships[@current_table.camelize.singularize]
        @relationships[@current_table.camelize.singularize].each do |relns|
          @output << "#{indent}has_many   :#{relns.underscore.pluralize}"
          @output << ", optional: true\n"
        end
      end
    end

    # Is the current table one of the tables that has a belongs_to relationship?
    def handle_define_belongs_to_relationships
      @relationships.each do |reln|
        if reln[1].include? @current_table.singularize.camelize
          @output << "#{indent}belongs_to :#{reln[0].underscore.singularize}"
          @output << ", optional: true\n"
        end
      end
    end

    def parse(schema_file)
      setup if !@setup
      @schema_file = schema_file
      if @schema_file && File.file?(@schema_file)
        File.open(@schema_file, 'r+').each do |line|
          handle_line(line)
        end
        true
      else
        false
      end
    end

    def entities_as_model_classes
      str = ''
      @entities.each do |entity|
        str << "class #{entity} < CDQManagedObject\nend\n\n"
      end
      str
    end
  end
end
