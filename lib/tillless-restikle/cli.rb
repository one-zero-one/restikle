require "tillless-restikle/version"
require 'tillless-restikle/parser'

module Restikle
  class CommandLine
    HELP_TEXT = %{Usage:
      restikle [options] <command> [arguments]

Commands:
      restikle [options] translate [-r remove_from_entities] [-i rails_schema] [-o cdq_schema]  # Generate CDQ schema file from Rails schema file

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

    def self.run_all
      actions = { 'translate' => TranslateAction }

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
      restikle [options] translate [-r remove_from_entities] [-i rails_schema] [-o cdq_schema]
      Parse a Rails schema file and output a CDQ-compatible schema file. If [-i rails_schama]
      or [-o cdq_schema] are not specified, then output goes to STDOUT. If [-r remove_from_entities]
      is provided, then that text will be striped from each entity name.

Options:
    }

    def option_parser
      super(HELP_TEXT).tap do |opts|
        opts.program_name = 'restikle translate'

        opts.on('-r', '--remove', 'Remove text from each table name') do
          @remove_from_entities = ARGV.shift
        end

        opts.on('-i', '--input', 'Rails schema file to parse, stdin if blank') do
          @schema_input_file = ARGV.shift
        end

        opts.on('-o', '--output', 'Name of cdq schema file to write, stdout if blank') do
          @schema_output_file = ARGV.shift
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
      end

      unless singleton_options_passed
        if @schema_input_file
          STDERR.print "Parsing: #{@schema_input_file} ... "
          parser = Restikle::Parser.new(remove_from_entities: @remove_from_entities)
          result = parser.parse(@schema_input_file)
          if result
            STDERR.puts "Done."
            write_output parser.output
          else
            STDERR.puts "Error: problem parsing '#{schema_file}'"
          end
        end
        unless result
          puts opts
        end
      end
    end

    def write_output(output)
      if @schema_output_file
        File.open(@schema_output_file, 'w+') do |file|
          file << output
        end
      else
        # STDERR.print "\n"
        puts output
      end
    end
  end
end
