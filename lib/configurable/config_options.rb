module Configurable

  # ConfigOptions lets you specify default configuration options.
  class ConfigOptions

    # Define a configuration option and its default. Default can be nil.
    #
    # If you provide a <tt>:config_file => true</tt> option, the default value will be treated
    # as a configuration file. Additionally, if you provide the <tt>:environment_based => false</tt>
    # option, the config file will not be treated as an environment-based config
    # If you provide a <tt>:keys => %w(list of keys)</tt> that list will be passed on to the 
    # config file so it checks for the presence of all of those keys.
    def option(name, default, opts={})
      options[name] = if opts[:config_file]
        opts[:environment_based] = true if opts[:environment_based].nil?
        ConfigFile.new(default, opts[:environment_based], opts[:keys] || [])
      else
        default
      end
    end

    # Returns the list of options that have already been configured.
    def options
      @options ||= {}
    end
  end
end
