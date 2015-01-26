require "tillless-restikle/version"
require 'tillless-restikle/cli/parser'
require 'tillless-restikle/concepts/entity'
require 'tillless-restikle/concepts/route'
require 'tillless-restikle/concepts/generator'

module Restikle
  class CommandLine
    HELP_TEXT = %{Usage:
      restikle [options] <command> [arguments]

Commands:
      # Generate CDQ schema file from Rails schema file
      restikle [options] translate  [-s rails_schema] [-e remove_from_entities] [-t rails_routes] [-p remove_from_paths] [-o cdq_schema] [-m models]

      # Parse routes and schema files and automatically determine resource 1:m relationships
      restikle [options] relationships [-s rails_schema] [-e remove_from_entities] [-t rails_routes] [-p remove_from_paths]

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

    def log(str)
      STDERR.print str if @debug 
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
end

require 'tillless-restikle/cli/translate_action'
require 'tillless-restikle/cli/relationships_action'
