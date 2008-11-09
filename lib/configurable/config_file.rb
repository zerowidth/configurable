module Configurable

  # ConfigFile represents a configuration file, used by the Configurable module for tracking
  # config defaults that use a config file from which to load data.
  # There are several scenarios involving config files, documented in Configurable.load_config,
  # that makes the use of a config file wrapper necessary.
  #
  # When you load from a ConfigFile instance, it returns a hash. This hash has an #alternate method defined on it,
  # which, as long as the config file is environment_based, allows you to retrieve an alternate environment
  # from the loaded data. E.g.
  #
  #   cf = ConfigFile.new("database.yml", true)
  #   config = cf.load("production") #=> {:host => "prod", ...}
  #   config.alternate("development") #=> {:host => "dev", ...}
  #
  # If an environment-based config is overridden with an alternate file or an alternate environment name,
  # the #alternate mechanism will still work. In any other case, including non-environment-based files and
  # overrides with hashes, the alternate method will still be defined but will raise a sensible exception.
  #
  class ConfigFile

    # used to extend the config hashes that #load and #load_from_alternate return
    module AlternateConfig
      attr_accessor :config_file
      def alternate(environment)
        config_file.alternate_config(environment)
      end
    end

    # Instantiate a ConfigFile.
    #
    # +file+ specifies where the config file is located
    # +environment_based+ instructs the config file whether or not to load an environment from the file.
    # +keys+ instructs the ConfigFile to check for the presence of all the given keys in the config.
    def initialize(file, environment_based, keys = [])
      @file, @environment_based, @keys = file, environment_based, keys
    end

    # Loads the given environment from the config file or error if the environment doesn't exist.
    #
    # If the ConfigFile isn't environment-based, the environment is ignored.
    # If the config file was initialized with keys checks to see that all of the specified keys exist
    # in the final configuration.
    def load(environment=nil)
      load_from_file(file, environment)
    end

    # In the case where an alternative to the default config file was given during the config loading
    # process in Configurable, this determines which environment to use to load the file.
    #
    # If the given alternative is a filename, it's used as an alternative file and the config gets loaded
    # from there instead.
    #
    # If it's an environment name, it's used as an alternative environment to use when loading from the
    # default config file.
    #
    # If it's a hash, it'll just return a dup of the hash.
    #
    # Everything this method returns will respond to the #alternate method.
    def load_from_alternate(global_environment, alternate)
      return nil unless alternate # handles nil/false values
      if alternate.kind_of?(Hash)
        @loaded_from = nil # can't retrieve alternate configs if it's been overridden!
        config = alternate.dup
        config.extend(AlternateConfig)
        config.config_file = self
        config
      elsif File.exist?(alternate)
        load_from_file(alternate, global_environment)
      else
        load_from_file(file, alternate)
      end
    end

    # Retrieve an alternate configuration environment from the previously-loaded config. Will raise an exception
    # if the previously-loaded config was overridden with a hash, or if the config file isn't environment-based.
    # This is used by the AlternateConfig module which extends a returned config hash.
    def alternate_config(environment)
      if loaded_from && environment_based?
        load_from_file(loaded_from, environment)
      else
        raise "config is not environment-based or was not loaded from a file," +
        " cannot select an alternate configuration!"
      end
    end

    private

    attr_reader :file, :keys
    attr_reader :loaded_from # where the config was loaded from

    def load_from_file(filename, environment)
      if File.exist?( filename ) then
        @loaded_from = filename
        configuration = YAML.load_file(filename)
        if environment_based?
          configuration = configuration[environment] or raise Error, "environment #{environment} " +
            "not found in #{filename}"
          configuration
        end
        keys.each do |k|
          raise Error, "key missing: #{k}" unless configuration.has_key?( k )
        end
        configuration.extend(AlternateConfig)
        configuration.config_file = self
        configuration
      else
        raise Error, "file not found: #{filename}"
      end
    end

    def environment_based?
      !!@environment_based
    end

  end

end
