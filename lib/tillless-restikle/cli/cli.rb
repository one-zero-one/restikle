require "tillless-restikle/version"
require 'tillless-restikle/cli/parser'

module Restikle
  class CommandLine
    HELP_TEXT = %{Usage:
      restikle [options] <command> [arguments]

Commands:
      # Generate CDQ schema file from Rails schema file
      restikle [options] translate [-r remove_from_entities] [-i rails_schema] [-o cdq_schema]

      # Parse routes and schema files and automatically determine resource 1:m relationships
      restikle [options] relationships [-s rails_schema] [-r rails_routes]

Options:
    }

    attr_reader :singleton_options_passed

    def option_parser(help_text = HELP_TEXT)
      OptionParser.new do |opts|
        opts.banner = help_text

        opts.on("-v", "--version", "Print Version") do
          @singleton_options_passed = true
          puts Restikle::VERSION
        end

        opts.on("-h", "--help", "Show this message") do
          @singleton_options_passed = true
          puts opts
        end

        opts.on('-d', '--debug', 'Show debug output') do
          @debug = true
        end
      end
    end

    def write_output(output, dest)
      if dest
        File.open(dest, 'w+') do |file|
          file << output
        end
      else
        # STDERR.print "\n"
        puts output
      end
    end

    def self.run_all
      actions = { 'translate' => TranslateAction, 'relationships' => RelationshipsAction }

      cli = self.new
      opts = cli.option_parser
      opts.order!
      action = ARGV.shift

      if actions[action]
        actions[action].new.run
      elsif !cli.singleton_options_passed
        puts opts
      end
    end
  end

  class TranslateAction < CommandLine
    HELP_TEXT = %{Usage:
      # Parse a Rails schema file and output a CDQ-compatible schema file.
      restikle [options] translate [-r remove_from_entities] [-i rails_schema] [-o cdq_schema] [-m models]

      Where:
        -r remove_from_entities      # Text will be striped from each entity name
        -i rails_schema              # Rails db/schema.rb file
        -o cdq_schema                # Output file for CDQ schema
        -m models                    # Output file for Ruby model classes

Options:
    }

    def option_parser
      super(HELP_TEXT).tap do |opts|
        opts.program_name = 'restikle translate'

        opts.on('-r', '--remove', 'Remove text from each table name') do
          @remove_from_entities = ARGV.shift if ARGV.size > 0
        end

        opts.on('-i', '--input', 'Rails schema file to parse, stdin if blank') do
          @schema_input_file = ARGV.shift if ARGV.size > 0
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
        STDERR.puts "   @schema_input_file: #{@schema_input_file}"
        STDERR.puts "  @schema_output_file: #{@schema_output_file}"
        STDERR.puts "@remove_from_entities: #{@remove_from_entities}"
        STDERR.puts "  @models_output_file: #{@models_output_file}"
      end

      unless singleton_options_passed
        parser = Restikle::Parser.new(remove_from_entities: @remove_from_entities)
        if @schema_input_file
          STDERR.print "   Parsing: #{@schema_input_file} ... "
          if (result = parser.parse(@schema_input_file))
            STDERR.puts "Done."
            write_output parser.output, @schema_output_file
          else
            STDERR.puts "Error: problem parsing '#{schema_file}'"
          end
        end
        if result && @models_output_file
          STDERR.print "Generating: #{@models_output_file} ... "
          out = parser.entities_as_model_classes
          STDERR.puts "Done."
          write_output out, @models_output_file
        end
        unless result
          puts opts
        end
      end
    end
  end

  class RelationshipsAction < CommandLine
    HELP_TEXT = %{Usage:
      # Parse routes and schema files and automatically determine resource 1:m relationships
      restikle [options] relationships [-s rails_schema] [-r rails_routes]

      Where:
      -s rails_schema              # Rails db/schema.rb file
      -r rails_routes              # Rails routes config from 'rake routes'

      Options:
    }

    def option_parser
      super(HELP_TEXT).tap do |opts|
        opts.program_name = 'restikle relationships'

        opts.on('-s', '--schema', 'Rails db/schema.rb file') do
          @rails_schema = ARGV.shift if ARGV.size > 0
        end

        opts.on('-r', '--routes', "Rails routes config from 'rake routes'") do
          @rails_routes = ARGV.shift if ARGV.size > 0
        end
      end
    end

    def run
      opts = option_parser
      opts.order!

      if @debug
        STDERR.puts "@rails_schema: #{@rails_schema}"
        STDERR.puts "@rails_routes: #{@rails_routes}"
      end

      unless singleton_options_passed
        result = false
        unless result
          puts opts
        end
      end
    end
  end
end
