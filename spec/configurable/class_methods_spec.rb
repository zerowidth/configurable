require File.expand_path(File.join(File.dirname(__FILE__), %w[.. spec_helper]))

describe Configurable::ClassMethods do

  before(:each) do
    @test_module = Module.new
    @test_module.class_eval do
      include Configurable
    end
  end

  describe ".default_configuration" do
    it "yields an instance of a configuration class" do
      yielded = false
      @test_module.default_configuration do |config|
        yielded = true
        config.should be_an_instance_of(Configurable::ConfigOptions)
      end
      yielded.should == true
    end

    it "yields the same instance on subsequent invocations" do
      yielded = nil
      @test_module.default_configuration do |config|
        yielded = config
      end
      second = nil
      @test_module.default_configuration do |config|
        second = config
      end

      yielded.should_not be_nil
      yielded.should equal(second)
    end
  end

  describe ".load_configuration" do
    before(:each) do
      @test_module.default_configuration do |config|
        config.option :file, Configurable.path("spec", "configs", "environment_config.yml"), :config_file => true
        config.option :basic, Configurable.path("spec", "configs", "basic_config.yml"),
          :config_file => true, :environment_based => false, :keys => %w(foo bar)
        config.option :option, "bar!"
        config.option :number, 1234
      end
      @default = {
        :file => {"foo" => "production", "bar" => "prod_value"},
        :basic => {"foo" => "foo value", "bar" => "bar value"},
        :option => "bar!",
        :number => 1234
      }
    end

    it "returns the default configuration for the given environment" do
      @test_module.load_configuration("production").should == @default
    end

    it "handles environment overrides for environment config files" do
      @default[:file] = {"foo" => "test", "bar" => "test_value"}
      @test_module.load_configuration("production", :file => "test").should == @default
    end

    it "handles alternate filename overrides for environment-based config files" do
      @default[:file] = {"foo" => "alt", "bar" => "prod"}
      @test_module.load_configuration("production",
        :file => Configurable.path("spec", "configs", "alternate_config.yml")).should == @default
    end

    it "handles overrides for non-file options" do
      @default[:number] = 456
      @test_module.load_configuration("production", :number => 456).should == @default
    end

    it "handles hash overrides for config file options" do
      @default[:file] = {"no" => "way!"}
      @test_module.load_configuration("production", :file => {"no" => "way!"}).should == @default
    end

    it "accepts nil or false for overrides to disable a config file option" do
      @test_module.load_configuration("production", :file => nil)[:file].should be_nil
    end

    it "clones the default values" do
      hash = {"what" => "no way!"}
      @default[:clone] = hash
      @test_module.default_configuration do |config|
        config.option :clone, hash
      end
      result = @test_module.load_configuration("production")
      result.should == @default
      result[:clone].should == hash # same contents
      result[:clone].should_not equal(hash) # but not the same object id
    end

    it "does not try to clone an IO default" do
      io = $stdout
      @default[:io] = io
      @test_module.default_configuration do |config|
        config.option :io, io
      end
      config = @test_module.load_configuration("production")
      config.should == @default
      config[:io].should equal(io)
    end

  end

end
