require 'slapd/version'
require 'thor'
require 'thor/group'

require 'slapd/cli/config'
require 'slapd/cli/init'

module Slapd
  module CLI
    class Root < Thor
      include Thor::Actions

      register Slapd::CLI::Init, 'init', 'init', 'Generates OpenLDAP configuration files.'
    end
  end
end
