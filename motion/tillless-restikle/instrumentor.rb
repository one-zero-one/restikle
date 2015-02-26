module Restikle
  # Builds on Restikle::Generator to provide support for working with Rails schema
  # and resources and an iOS, CDQ and RestKit front-end using RubyMotion.
  class Instrumentor < Restikle::Generator
    include CDQ

    # Depending on whether or not the app is running as standard Ruby,
    # or inside RubyMotion, then load the file using the appropriate
    # platform mechanism.
    def turn_file_into_data_using_platform_specific_mechanism(file)
      NSData.dataWithContentsOfFile(NSBundle.mainBundle.pathForResource(file, ofType: nil)).to_str
    end

    # Use the contents of #routes, #entities and #relationships to assemble a
    # set of RestKit resource mappings. Unless mgr is provided, Instrumentor
    # will make use of Restikle::ResourceManager.manager.
    def build_mappings(mgr)
      @mappings_created = 0
      mgr ||= manager
      @entities.each do |entity|
        rk_mappings_for(entity.entity_name, related_entities_for(entity.entity_name)).each do |mapping|
          mgr.addRequestDescriptor(
            RKRequestDescriptor.requestDescriptorWithMapping(
              mapping[:request_descriptor][:request_mapping],
              objectClass: mapping[:request_descriptor][:object_class],
              rootKeyPath: mapping[:request_descriptor][:root_key_path],
              method: mapping[:request_descriptor][:method]
            )
          )
          mgr.addResponseDescriptor(
            RKResponseDescriptor.responseDescriptorWithMapping(
              mapping[:response_descriptor][:response_mapping],
              method: mapping[:response_descriptor][:method],
              pathPattern: mapping[:response_descriptor][:path_pattern],
              keyPath: mapping[:response_descriptor][:key_path],
              statusCodes: mapping[:response_descriptor][:status_codes]
            )
          )
          @mappings_created += 1
        end
      end
      true
    end

    # Number of RestKit mappings created on last run, or -1 if
    # #build_mappings has not been called.
    def mappings_created
      @mappings_created || -1
    end

    def cdq_attributes_for_entity(entity_name)
      out = ""
      attrs = {}
      entity = @entities.find {|e| e.entity_name == entity_name}
      if entity
        cdq_entities = CDQ.cdq.models.current.entities
        cdq_entities.each do |ent|
          out << "\n #{ent.name}"
        end
      end
      out
    end

    # Build a RestKit request and response mapping for each path for entity,
    # where entity_name is known to Restkile following loading of routes and
    # schema files. Response is an array of mappings, with each item:
    # [ { route: {}, request_description: {}, response_descriptor: {} }]
    # If related_entities is provided, then RK property mappings will also
    # be made for each.
    def rk_mappings_for(entity_name, related_entities=[])
      mappings = []
      entity = @entities.find {|e| e.entity_name == entity_name}
      if entity
        @routes.each do |route|
          if route.path.index(entity.entity_name.pluralize.underscore)
            mappings << {
              route: route,
              request_descriptor: {
                request_mapping:  RKObjectMapping.requestMapping,
                object_class:     entity.entity_name,
                root_key_path:    route.path,
                method:           rk_request_method_for(route.verb)
              },
              response_descriptor: {
                response_mapping: rk_mapping_for_entity_for_name(entity.entity_name, related_entities),
                path_pattern:     route.path,
                key_path:         route.key_path,
                method:           rk_request_method_for(route.verb),
                status_codes:     RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)
              }
            }
          end
        end
      end
      mappings
    end

    def rk_mapping_for_entity_for_name(entity_name, related_entities=[])
      entity_name_attr_hash = attributes_for_entity_as_hash(entity_name)
      RKEntityMapping.mappingForEntityForName(entity_name, inManagedObjectStore: store).tap do |outer|
        outer.addAttributeMappingsFromDictionary(entity_name_attr_hash)
        related_entities.each do |related_entity|
          # Only build property mappings for related_entities that we know
          # have been defined from the currently loaded schema, otherwise
          # RestKit won't be able to map onto those entities
          if entities.any? { |ent| ent.entity_name == related_entity}
            RKEntityMapping.mappingForEntityForName(related_entity, inManagedObjectStore: store).tap do |inner|
              inner.addAttributeMappingsFromDictionary(entity_name_attr_hash)
              outer.addPropertyMapping(
                RKRelationshipMapping.relationshipMappingFromKeyPath(
                  related_entity.pluralize.underscore,
                  toKeyPath: "#{related_entity.pluralize.underscore}",
                  withMapping: inner
                )
              )
            end
          end
        end
      end
    end

    # Creates a simple array of attributes for an entity
    def attributes_for_entity_as_array(entity_name)
      attrs  = []
      entity = CDQ.cdq.models.current.entities.find {|e| e.name == entity_name}
      entity.attributesByName.each { |attr| attrs << attr[0] } if entity
      attrs
    end

    # Creates a hash of attribute mappings
    def attributes_for_entity_as_hash(entity_name)
      attrs  = {}
      entity = CDQ.cdq.models.current.entities.find {|e| e.name == entity_name}
      entity.attributesByName.each { |attr| attrs[attr[0]] = attr[0] } if entity
      xform_attribute_hash_for_rm_reserved_words(attrs)
      attrs
    end


    # List of words that are reserved in RM, and so can't be attribute names for entities
    RM_RESERVED_WORDS = {
      'descrip' => 'description'
    }
    # Given a hash, go through and replace any 'to' value that is in the map of reserved
    # words. Will use RM_RESERVED_WORDS if reserved_words is nil.
    def xform_attribute_hash_for_rm_reserved_words(hash, reserved_words=nil)
      reserved_words ||= RM_RESERVED_WORDS
      to_del = []
      to_add = []
      hash.each do |from,to|
        if reserved_words.has_key?(to)
          to_del << from
          to_add << { reserved_words[to] => to }
        end
      end
      to_del.each {|k| hash.delete k }
      to_add.each {|k| hash.merge! k }
      hash
    end

    # Get a reference to the current ResourceManager's RKObjectManager
    def manager
      Restikle::ResourceManager.manager
    end

    # Get a reference to the current ResourceManager's managedObjectStore
    def store
      Restikle::ResourceManager.store
    end

    RK_REQUEST_METHODS = {
      get:      RKRequestMethodGET,
      post:     RKRequestMethodPOST,
      put:      RKRequestMethodPUT,
      delete:   RKRequestMethodDELETE,
      head:     RKRequestMethodHEAD,
      patch:    RKRequestMethodPATCH,
      options:  RKRequestMethodOPTIONS,
      any:      RKRequestMethodAny
    }
    # Return a RestKit constant for a HTTP verb string (or symbol)
    def rk_request_method_for(method)
      RK_REQUEST_METHODS[method.to_s.strip.downcase.to_sym]
    end

    RK_REQUEST_METHOD_STRINGS = {
      RKRequestMethodGET     => 'get',
      RKRequestMethodPOST    => 'post',
      RKRequestMethodPUT     => 'put',
      RKRequestMethodDELETE  => 'delete',
      RKRequestMethodHEAD    => 'head',
      RKRequestMethodPATCH   => 'patch',
      RKRequestMethodOPTIONS => 'options',
      RKRequestMethodAny     => 'any'
    }
    # Return a string versiuon of a RestKit constant for a HTTP verbs
    def rk_request_method_string_for(method)
      RK_REQUEST_METHOD_STRINGS[method]
    end
  end
end
