require File.expand_path(File.join(File.dirname(__FILE__), %w[.. spec_helper]))

describe Configurable::ConfigOptions do

  before(:each) do
    @options = Configurable::ConfigOptions.new
  end

  describe "#options" do
    it "returns the hash of options given so far" do
      @options.options.should == {}
    end
  end

  describe "#option" do
    it "stores the option and its default" do
      @options.option :foo, "default value"
      @options.options.should == {:foo => "default value"}
    end

    describe "with :config_file => true" do
      it "stores the default as an instance of ConfigFile" do
        @options.option :thing, "filename.yml", :config_file => true
        @options.options[:thing].should be_an_instance_of(Configurable::ConfigFile)
      end

      describe "and :environment_based => false" do
        it "initializes ConfigFile with the environment_based flag set to false" do
          Configurable::ConfigFile.should_receive(:new).with("filename.yml", false, [])
          @options.option :thing, "filename.yml", :config_file => true, :environment_based => false
        end
      end

      describe "and :keys => a list of keys" do
        it "initializes ConfigFile with the keys as well as the filename" do
          Configurable::ConfigFile.should_receive(:new).with("filename.yml", true, %w(foo bar))
          @options.option :thing, "filename.yml", :config_file => true, :keys => %w(foo bar)
        end
      end
    end

  end

end
