# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

begin
  require 'bones'
  Bones.setup
rescue LoadError
  load 'tasks/setup.rb'
end

ensure_in_path 'lib'
require 'configurable'

task :default => 'spec:run'

PROJ.name = 'configurable'
PROJ.authors = 'Nathan Witmer'
PROJ.email = 'nwitmer@gmail.com'
PROJ.url = 'http://github.com/aniero/configurable'
PROJ.version = Configurable::VERSION
PROJ.rubyforge.name = 'configurable'

PROJ.spec.opts << '--color --format specdoc'
PROJ.ruby_opts = []
