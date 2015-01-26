require "tillless-restikle/version"
require 'tillless-restikle/cli/parser'
require 'tillless-restikle/cli/cli'
require 'tillless-restikle/concepts/entity'
require 'tillless-restikle/concepts/route'
require 'tillless-restikle/concepts/generator'

module Restikle
  class TranslateAction < Restikle::CommandLine
    HELP_TEXT = %{Usage:
      # Parse a Rails schema file and output a CDQ-compatible schema file.
      restikle [options] translate [-s rails_schema] [-e remove_from_entities] [-t rails_routes] [-p remove_from_paths] [-o cdq_schema] [-m models]

      Where:
        -s rails_schema              # Rails db/schema.rb file
        -e remove_from_entities      # Text will be striped from each entity name
        -t rails_routes              # Rails routes config from 'rake routes'
        -p remove_from_paths         # Text will be striped from each resource path
        -o cdq_schema                # Output file for CDQ schema
        -m models                    # Output file for Ruby model classes

Options:
    }

    def option_parser
      super(HELP_TEXT).tap do |opts|
        opts.program_name = 'restikle translate'

        opts.on('-s', '--schema', 'Rails schema file to parse, stdin if blank') do
          @rails_schema = ARGV.shift if ARGV.size > 0
        end

        opts.on('-e', '--remove-from-entities', 'Remove text from each table name') do
          @remove_from_entities = ARGV.shift if ARGV.size > 0
        end

        opts.on('-t', '--routes', "Rails routes config from 'rake routes'") do
          @rails_routes = ARGV.shift if ARGV.size > 0
        end

        opts.on('-p', '--remove-from-paths', 'Remove text from each resource path') do
          @remove_from_paths = ARGV.shift if ARGV.size > 0
        end

        opts.on('-o', '--output', 'Name of cdq schema file to write, stdout if blank') do
          @schema_output_file = ARGV.shift if ARGV.size > 0
        end

        opts.on('-m', '--models', 'Name of Ruby app models file to write, ignored if blank') do
          @models_output_file = ARGV.shift if ARGV.size > 0
        end
      end
    end

    def run
      opts = option_parser
      opts.order!

      if @debug
        log "        @rails_schema: #{@rails_schema}\n"
        log "  @schema_output_file: #{@schema_output_file}\n"
        log "@remove_from_entities: #{@remove_from_entities}\n"
        log "        @rails_routes: #{@rails_routes}\n"
        log "   @remove_from_paths: #{@remove_from_paths}\n"
        log "  @models_output_file: #{@models_output_file}\n"
      end

      unless singleton_options_passed

        # Load the routes and entities into a generator so that we have access to the relationships
        log "   Building generator: "
        generator = Restikle::Generator.new(
          remove_from_entities: @remove_from_entities,
          remove_from_paths:    @remove_from_paths
        )
        log "Done\n"

        log "       Loading schema: #{@rails_schema} "
        if (result = generator.load_schema(file: @rails_schema, remove_from_entities: @remove_from_entities))
          log "Done\n"
          log "       Loading routes: #{@rails_routes} "
          result = generator.load_routes(file: @rails_routes, remove_from_paths: @remove_from_paths)
          log "Done\n" if result
        end

        if result
          parser = Restikle::Parser.new(remove_from_entities: @remove_from_entities, relationships: generator.relationships)
          if @rails_schema
            log "              Parsing: #{@rails_schema} ... "
            if (result = parser.parse(@rails_schema))
              log "Done\n"
              write_output parser.output, @schema_output_file
            else
              STDERR.puts "Error: problem parsing '#{schema_file}'"
            end
          end
          if result && @models_output_file
            log "Generating: #{@models_output_file} ... "
            out = parser.entities_as_model_classes
            log "Done\n"
            write_output out, @models_output_file
          end
        end

        unless result
          puts opts
        end
      end
    end
  end
end
