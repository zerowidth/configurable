
require File.join(File.dirname(__FILE__), %w[spec_helper])

describe Configurable do

  describe "when included into a module" do
    it "extends the module with methods from Configurable::ClassMethods" do
      m = Module.new
      m.class_eval { include Configurable }
      (class << m; self; end).included_modules.should include(Configurable::ClassMethods)
    end
  end

end
