module Restikle
  class Entity
    attr_accessor :entity_name, :entity_matcher, :remove_from_entities

    RAILS_SCHEMA_MATCHER    = /.*create_table\s\"(.*)\".*/
    CDQ_SCHEMA_MATCHER      = /.*entity\s\"(.*)\".*/
    DEFAULT_ENTITY_MATCHER  = RAILS_SCHEMA_MATCHER

    # Create a new entity. If args is a string, attempt to parse the string using DEFAULT_ENTITY_MATCHER
    # as the mecahinsm to extract the entity name from the string. If args is a hash, then pull out
    # :entity_name directly. Also look for :entity_matcher if provided, otherwise assume the default.
    # If :rails is provided in the hash, then use RAILS_SCHEMA_MATCHER, if :cdq is provided in the hash,
    # then use CDQ_SCHEMA_MATCHER, and if :string is provided, then attempt to parse that string into an
    # entity. If :remove_from_entities is provided, then each entity will have that string removed from
    # the entity as it is processed.
    def self.new(args={})
      super(args).tap do |r|
        if args.instance_of? String
          r.entity_matcher ||= DEFAULT_ENTITY_MATCHER
          r.entity_name    =   r.parse_schema_string(args)
        else
          r.remove_from_entities =   args[:remove_from_entities]
          r.entity_name          =   args[:entity_name]
          r.entity_matcher       =   args[:entity_matcher]
          r.entity_matcher       ||= args[:rails] ? RAILS_SCHEMA_MATCHER : (args[:cdq] ? CDQ_SCHEMA_MATCHER : DEFAULT_ENTITY_MATCHER)
          r.entity_name          ||= r.parse_schema_string(args[:string])
        end
      end
    end

    # Use :entity_matcher to extract the :entity_name from a string
    def parse_schema_string(str)
      if str && (match_data = str.match @entity_matcher)
        en = match_data[1]
        en.gsub!(@remove_from_entities, '') if @remove_from_entities
        en.strip.singularize.camelize
      else
        nil
      end
    end

    # True if the entity has a valid entity name specified
    def valid?
      !@entity_name.nil?
    end

    # Human readable output
    def to_s
      "#{@entity_name}"
    end

    # For sorting assume that entity_name is the sort variable
    def <=> (other) #1 if self>other; 0 if self==other; -1 if self<other
      @entity_name <=> other.entity_name
    end
  end
end
