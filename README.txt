configurable
    by Nathan Witmer
    http://zerowidth.com
    http://github.com/aniero/configurable

== DESCRIPTION:

Configurable is a simple configuration description and loading mechanism for your modules or classes.

Configurable makes it easy to set default values for a configuration setup and then easily load and override those default settings. It supports YAML config files, either simple data or environment-based with environment name/value groupings like rails' database.yml.

This code was extracted from a production framework, where it manages configuration defaults and initialization for a base gem along with several supporting gems which add new features and config settings to the initialization process.

== FEATURES/PROBLEMS:

* Describe defaults, including config file paths and settings
* Load a configuration from the specified defaults with easy overrides
* Environment-aware config files, rails-style, so you can have multiple environments in your configuration files
* Easy to add on additional configuration options from supporting code that need to hook into the config initialization process
* Access to alternate configurations for settings loaded from environment-based config files

== SYNOPSIS:

  require "configurable"

  class MyScript
    include Configurable

    # set up the defaults
    default_configuration do |config|
      config.option :database, "database.yml", :config_file => true
      config.option :log_level, :info
      config.option :output_location, "/tmp"
    end

    attr_reader :config

    def initialize(environment, overrides={})
      # load the configuration using the provided environment and override values
      @config = self.class.load_configuration(environment, overrides)
    end

  end

  # simple operation:
  a = MyScript.new("production")
  a.config[:database] #=> {"user" => "bob", "host" => "production-db"...}
  a.config[:log_level] #=> :info

  # override default settings
  b = MyScript.new "production", :log_level => :debug, :database => "other_db_config.yml"
  b.config[:log_level] #=> :debug
  b.config[:database] #=> {"user" => "fred", "host" => "other-db" ...}

  # or override the config file settings directly
  b = MyScript.new "production", :database => {"user" => "overridden", "host" => "owned"}
  b.config[:database] #=> {"user" => "overridden", "host" => "owned"}

  # add a new setting:
  MyScript.default_configuration { |config| config.option :flag, false }
  MyScript.new.config[:flag] #=> false

  # retrieve an alternate configuration from an environment-based config file
  a = MyScript.new("production")
  a.config[:database] #=> {"user" => "bob", "host" => "production-db", ...}
  a.config[:database].alternate("development") #=> {"user" => "joe", "host" => "development-db", ...}

== REQUIREMENTS:

* mrbones for development

== INSTALL:

  sudo gem install aniero-configurable --source http://gems.github.com

== LICENSE:

(The MIT License)

Copyright (c) 2008 Nathan Witmer

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
