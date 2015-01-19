require "tillless-restikle/version"

module Restikle
  class CommandLine
    HELP_TEXT = %{Usage:
      restikle [options] <command> [arguments]
      Commands:
      restikle [options] translate <rails_schema.rb>  # From a Rails scheam.rb file and output a CDQ schema.rb file
      Options:
    }

    attr_reader :singleton_options_passed

    def option_parser(help_text = HELP_TEXT)
      OptionParser.new do |opts|
        opts.banner = help_text

        opts.on("-v", "--version", "Print Version") do
          @singleton_options_passed = true
          puts TilllessRestikle::VERSION
        end

        opts.on("-h", "--help", "Show this message") do
          @singleton_options_passed = true
          puts opts
        end
      end
    end

    def self.run_all
      actions = { translate: TranslateAction }

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
      restikle [options] translate <rails_schema.rb>
      Convert a Rails 'schema.rb' file into something suitable for CDQ
      Options:
    }

    def option_parser
      super(HELP_TEXT).tap do |opts|
        opts.program_name = "restikle translate"

        opts.on("-d", "--dry-run", "Do a Dry Run") do
          @dry_run = "dry_run"
        end
      end
    end

    def run
      opts = option_parser
      opts.order!

      object = ARGV.shift

      unless singleton_options_passed
        case object
        when 'translate'
          rails_schema_file = ARGV.shift
          if rails_schema_file
            puts "Parsing: #{rails_schema_file} ..."
          else
            puts "Please supply a Rails 'schema.rb' file name"
            puts opts
          end
        else
          puts "Invalid command: #{object}"
          puts opts
        end
      end
    end
  end
end
