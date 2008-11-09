module Configurable

  module ClassMethods

    # Define a default configuration for the class/module.
    # Yields a ConfigOptions instance for setting config options and defaults.
    # Can be called multiple times to add additional options to the configuration.
    def default_configuration
      @default_config ||= ConfigOptions.new
      yield @default_config
    end

    # Loads the configuration from the given +environment+, overriding where specified by
    # the +overides+. Returns a hash containing the calculated configuration.
    # There are several ways to provide overrides.
    #
    # Given the configuration:
    #
    #   default_configuration do |config|
    #     config.option :flag, true
    #     config.option :number, 1234
    #     config.option :basic_config, "basic.yml", :config_file => true, :keys => %w(foo bar)
    #     config.option :config, "config.yml", :config_file => true
    #   end
    #
    # For simple default values, just provide an alternative value:
    #
    #   load_configuration("env", :flag => false, :number => 456)
    #
    # For environment-based config files, you can override them by providing a new filename
    # or a different environment:
    #
    #   load_config("env", :config => "alternative.yml")
    #   load_config("production", :config => "production_readonly")
    #
    # For basic configuration files, you can provide an alternative filename:
    #
    #   load_config("env", :basic_config => "alternative.yml")
    #
    # If you need to override a configuration default that is *not* a configuration file, but
    # want the overridden value to be treated as such, wrap it up as a ConfigFile instance, e.g.
    #
    #   load_configuration("env", :my_config => ConfigFile.new("my_config.yml"))
    #
    def load_configuration(environment, overrides={})
      config = {}

      sanity_check(overrides)
      default_config.options.each do |key, default|

        if default.instance_of?(ConfigFile)
          if overrides.has_key?(key)
            # for file-based configs, the override could be a different filename OR a different environment name
            # or, this could be a hash-based override.
            # This lets the config file manage the #alternate extensions to whatever it returns, so
            # that it's possible to get an alternate environment back if it exists
            config[key] = default.load_from_alternate(environment, overrides[key])
          else
            config[key] = default.load(environment)
          end
        else
          config[key] = if overrides.has_key?(key)
            overrides[key]
          else
            # use a deep copy if possible
            default.kind_of?(IO) ? default : Marshal.load(Marshal.dump(default))
          end
        end
      end
      config
    end

    private

    attr_reader :default_config

    def sanity_check(overrides)
      overrides.keys.each do |key|
        unless default_config.options.keys.include?(key)
          raise Error, "cannot override nonexistent config setting #{key.inspect}"
        end
      end
    end

  end

end