require 'restikle/version'
require 'restikle/cli/parser'
require 'restikle/cli/cli'
require 'restikle/concepts/entity'
require 'restikle/concepts/route'
require 'restikle/concepts/generator'

module Restikle
  class RelationshipsAction < Restikle::CommandLine
    HELP_TEXT = %{Usage:
      # Parse routes and schema files and automatically determine resource 1:m relationships
      restikle [options] relationships [-s rails_schema] [-e remove_from_entities] [-t rails_routes] [-p remove_from_paths]

      Where:
      -s rails_schema              # Rails db/schema.rb file
      -e remove_from_entities      # Text will be striped from each table name
      -t rails_routes              # Rails routes config from 'rake routes'
      -p remove_from_paths         # Text will be striped from each resource path

      Options:
    }

    def option_parser
      super(HELP_TEXT).tap do |opts|
        opts.program_name = 'restikle relationships'

        opts.on('-s', '--schema', 'Rails db/schema.rb file') do
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
      end
    end

    def run
      opts = option_parser
      opts.order!

      if @debug
        log "        @rails_schema: #{@rails_schema}\n"
        log "@remove_from_entities: #{@remove_from_entities}\n"
        log "        @rails_routes: #{@rails_routes}\n"
        log "   @remove_from_paths: #{@remove_from_paths}\n"
      end

      unless singleton_options_passed
        result = false
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
          generator.dump_relationships
        else
          puts opts
        end
      end
    end
  end
end
