# restikle

Easily work with Rails routes and schemas in an iOS RestKit+CDQ project.

## Installation

Add this line to your application's Gemfile:

    gem 'restikle'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install restikle


## Note: very preliminary release

This is a very, very early 0.0.1 release of `restikle`. Please do not rely it for production code. In fact, I would not recommend relying on it at all the moment. At least until it gets towards a 0.1.0 release.


## Background

Restikle is designed to make it easy to create all of the runtime integration components necessary for an iOS app using [CoreData](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/CoreData/Articles/cdBasics.html), [RestKit](https://github.com/RestKit/RestKit), and [CDQ](https://github.com/infinitered/cdq) to talk to a RESTful Rails back-end.

It does this by analysing the Rails project's `db/schema.rb` file (referred to as `schema`), along with the output of `rake routes` (referred to as `routes`). The schema file contains a list of all of the entities that the service is using, and the routes description contains the exposed RESTful resources.

When parsed, these two files provide enough information to create a CDQ schema file for the iOS project, as well as enough information to create all of the runtime mapping configuration necessary to RestKit to bind to that CoreData model. Without this, a programmer using RestKit is forced to create an extraordinary amount of boilerplate code that is hard to maintain. With Restikle, runtime configuration of RestKit can be reduced to about four or five lines of code.

Restikle came about during the development of [Tillless](www.tillless.com), as we looked for ways to make integrating our front-end iOS apps with a RESTful Rails back-end. Although CoreData, RestKit, and CDQ are all enormously powerful, there's quite a bit of fiddling around to get them working together, and as with many iOS tools, there's also a lot of boilerplate code to write and setup. The intent with Restikle is to make that stuff disappear as much as possible.

## Usage

Restikle has two components: a command line utility for generating the iOS / CoreData / CDQ schema file, and a class called `Restikle::ResourceManager` which is used to load the schema and routes data and create all of the applicable RestKit request and response mappings that enable interaction with the Rails back-end.

### restikle

<pre>
$ restikle translate
Usage:
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

  -v, --version                    Print Version
  -h, --help                       Show this message
  -d, --debug                      Show debug output
  -s, --schema                     Rails schema file to parse, stdin if blank
  -e, --remove-from-entities       Remove text from each table name
  -t, --routes                     Rails routes config from 'rake routes'
  -p, --remove-from-paths          Remove text from each resource path
  -o, --output                     Name of cdq schema file to write, stdout if blank
  -m, --models                     Name of Ruby app models file to write, ignored if blank
</pre>

For example, assuming that `resources/schema_rails.rb` is a `db/schema.rb` from a Rails project, and `resources/routes_rails.txt` is the output of running `rake routes` in that project. The following command will generate a
`schemas/0001_initial.rb` file, suitable for use with CoreData and CDQ.

<pre>
$ restikle translate -s resources/schema_rails.rb -e 'spree_' -t resources/routes_rails.txt -p '/api/' -o schemas/0001.rb
</pre>

The `-e` and `-p` options are useful for removing repeated text from the input files. For example, the [Spree Commerce](https://github.com/spree/spree) schema file has `spree_` in front of every table definition, and the routes all have `/api/` in front of them. If you need to remove this kind of repeating text, then just supply `-e` or `-p` paramaters to the `translate` command.

For the purposes of this example, the schema is based on the the [Spree Commerce](https://github.com/spree/spree) open-source e-commerce gem. This is used because it is a) very sophisticated, b) a great example of the kinds of complex back-end that you might want to integrate with, and c) freely available as an open-source project.

### Restikle::ResourceManager

Once you have created the schema file, you will want to setup Restikle for runtime use. `app/app_delegate.rb` provides simple runtime configuration example that uses the same inputs as the specs. To configure the full set of RestKit mappings based on schema and routes files, use the following:

<pre>
Restikle::ResourceManager.setup
Restikle::ResourceManager.load_schema(file: 'schema_rails.rb', remove_from_entities: 'spree_')
Restikle::ResourceManager.load_routes(file: 'routes_rails.txt', remove_from_paths: '/api/')
Restikle::ResourceManager.build_mappings
</pre>

For more information on runtime use, please see the test cases in `spec/`.


## Known problems

* *Performance* of the assembly step to create the RestKit mappings (via Restikle::ResourceManager#build_mappings) is incredibly slow (at leat for the example schema and routes files). This can almost certainly be tidied up, and I will look to do that once I have more of the functionality bedded down.
* There are a couple of issues with the generated *CDQ / xcdatamodel* schema files that have something to do with the way that inverse relationships are captured. I have not been able to work them out yet. Stay tuned.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
