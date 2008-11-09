# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{configurable}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nathan Witmer"]
  s.date = %q{2008-11-09}
  s.description = %q{Configurable is a simple configuration description and loading mechanism for your modules or classes.  Configurable makes it easy to set default values for a configuration setup and then easily load and override those default settings. It supports YAML config files, either simple data or environment-based with environment name/value groupings like rails' database.yml.  This code was extracted from a production framework, where it manages configuration defaults and initialization for a base gem along with several supporting gems which add new features and config settings to the initialization process.}
  s.email = %q{nwitmer@gmail.com}
  s.extra_rdoc_files = ["History.txt", "README.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.txt", "Rakefile", "configurable.gemspec", "lib/configurable.rb", "lib/configurable/class_methods.rb", "lib/configurable/config_file.rb", "lib/configurable/config_options.rb", "spec/configs/alternate_config.yml", "spec/configs/basic_config.yml", "spec/configs/environment_config.yml", "spec/configs/invalid_basic_config.yml", "spec/configurable/class_methods_spec.rb", "spec/configurable/config_file_spec.rb", "spec/configurable/config_options_spec.rb", "spec/configurable_spec.rb", "spec/spec_helper.rb", "tasks/ann.rake", "tasks/bones.rake", "tasks/gem.rake", "tasks/git.rake", "tasks/manifest.rake", "tasks/notes.rake", "tasks/post_load.rake", "tasks/rdoc.rake", "tasks/rubyforge.rake", "tasks/setup.rb", "tasks/spec.rake", "tasks/svn.rake", "tasks/test.rake"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/aniero/configurable}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{configurable}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Configurable is a simple configuration description and loading mechanism for your modules or classes}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bones>, [">= 2.1.0"])
    else
      s.add_dependency(%q<bones>, [">= 2.1.0"])
    end
  else
    s.add_dependency(%q<bones>, [">= 2.1.0"])
  end
end
