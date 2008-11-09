require File.expand_path(File.join(File.dirname(__FILE__), %w[.. spec_helper]))

describe Configurable::ConfigFile do

  before(:each) do
    @environment_config = Configurable.path "spec", "configs", "environment_config.yml"
    @alternate_config = Configurable.path "spec", "configs", "alternate_config.yml"
    @basic_config = Configurable.path "spec", "configs", "basic_config.yml"
    @invalid_basic_config = Configurable.path "spec", "configs", "invalid_basic_config.yml"
  end

  describe "when initialized with a filename and a flag indicating it's environment based" do
    before(:each) do
      @config_file = Configurable::ConfigFile.new(@environment_config, true)
    end

    describe " #load" do
      it "loads the given environment from the config file, returning a hash" do
        @config_file.load("production").should == {"foo" => "production", "bar" => "prod_value"}
      end

      it "raises an exception if the file doesn't exist" do
        @config_file = Configurable::ConfigFile.new("foo.yml", true)
        lambda do
          @config_file.load("production")
        end.should raise_error(Configurable::Error, /not found/)
      end

      it "raises an exception if the environment doesn't exist in the config file" do
        lambda do
          @config_file.load("development")
        end.should raise_error(Configurable::Error, /development.*not found/)
      end

      it "extends the returned hash with an alternate method" do
        @config_file.load("production").should respond_to(:alternate)
      end

      describe " #alternate on the returned hash" do
        it "loads an alternative environment from the config" do
          @config_file.load("production").alternate("test").should == {"foo" => "test", "bar" => "test_value" }
        end
      end

    end

    describe " #load_from_alternate" do

      describe "with an alternate file" do
        it "loads the global environment from the alternate file" do
          @config_file.load_from_alternate("production", @alternate_config).should == {
            "foo" => "alt", "bar" => "prod"
          }
        end

        it "does not override the stored filename" do
          @config_file.load_from_alternate("production", @alternate_config).should == {
            "foo" => "alt", "bar" => "prod"
          }
          @config_file.load("production").should == {"foo" => "production", "bar" => "prod_value"}
        end

        it "extends the returned hash with an alternate method" do
          @config_file.load_from_alternate("production", @alternate_config).should respond_to(:alternate)
        end

        describe " #alternate on the returned hash" do
          it "loads the alternate environment, but still using the alternate file" do
            @config_file.load_from_alternate("production", @alternate_config).alternate("test").should ==
              {"foo"=>"alt_test", "bar"=>"test"}
          end
        end

      end

      describe "with an alternate environment" do
        before(:each) do
          @config = @config_file.load_from_alternate("production", "test")
        end

        it "loads the alternate environment from the default configuration file" do
          @config.should == {"foo" => "test", "bar" => "test_value" }
        end

        it "raises an exception if the alternate environment doesn't exist" do
          lambda do
            @config_file.load_from_alternate("production", "development")
          end.should raise_error(Configurable::Error, /development.*not found/)
        end

        it "extends the hash with an alternate method" do
          @config.should respond_to(:alternate)
        end

        describe " #alternate on the returned hash" do
          it "loads the alternate environment from the config" do
            @config.alternate("production").should == {"foo" => "production", "bar" => "prod_value"}
          end
        end

      end

      describe "with an alternate hash" do
        before(:each) do
          @config = @config_file.load_from_alternate("production", {"foo" => "lol", "what" => "no way"})
        end

        it "returns the hash" do
          @config.should == {"foo" => "lol", "what" => "no way"}
        end

        it "extends the hash with an alternate method" do
          @config.should respond_to(:alternate)
        end

        describe " #alternate on the returned hash" do
          it "raises an exception" do
            lambda do
              @config.alternate("stuff")
            end.should raise_error(RuntimeError, /cannot.*alternate/)
          end
        end

      end

      it "returns nil with nil given as the alternate" do
        @config_file.load_from_alternate("production", nil).should == nil
      end

      it "returns nil with false given as the alternate" do
        @config_file.load_from_alternate("production", false).should == nil
      end

    end

  end

  describe "when initialized with a filename and not loading from the environment" do

    before(:each) do
      @config_file = Configurable::ConfigFile.new(@basic_config, false)
    end

    describe " #load" do
      it "loads the config regardless of the environment" do
        @config_file.load("whatever").should == {"foo" => "foo value", "bar" => "bar value"}
      end

      it "extends the returned hash with an alternate method" do
        @config_file.load("whatever").should respond_to(:alternate)
      end

      describe " #alternate on the returned hash" do
        it "raises an exception" do
          lambda do
            @config_file.load("whatever").alternate("stuff")
          end.should raise_error(RuntimeError, /cannot.*alternate/)
        end
      end

    end

  end

  describe "when initialized with a list of keys" do
    before(:each) do
      @config_file = Configurable::ConfigFile.new(@basic_config, false, %w(foo bar))
    end

    describe "#load" do
      it "loads the configuration" do
        @config_file.load("env").should == {"foo" => "foo value", "bar" => "bar value"}
      end
    end

    describe "and the file doesn't have all the keys" do
      before(:each) do
        @config_file = Configurable::ConfigFile.new(@invalid_basic_config, false, %w(foo bar))
      end

      describe "#load" do
        it "raises an exception regarding the missing key(s)" do
          lambda { @config_file.load("env") }.should raise_error(Configurable::Error, /key.*bar/)
        end
      end

    end

    describe "#load when the file doesn't contain all the keys" do
    end

  end

end
