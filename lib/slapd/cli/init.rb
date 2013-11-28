module Slapd
  module CLI
    class Init < Thor::Group
      include Thor::Actions
      include Slapd::CLI::Config

      def self.source_root
        File.expand_path(File.join(File.dirname(__FILE__), '../../..'))
      end

      def generate_working_dir
        empty_directory('.slapd')
      end

      def generate_config
        empty_directory('config')
        empty_directory('config/slapd')
        template('templates/config/slapd/slapd.plist', 'config/slapd/slapd.plist')
        template('templates/config/slapd/slapd.conf', 'config/slapd/slapd.conf')
        template('templates/config/slapd/groups.ldif', 'config/slapd/groups.ldif')
        template('templates/config/slapd/person.ldif', 'config/slapd/person.ldif')
      end

      def update_gitignore
        say_status 'updating', '.gitignore', :green

        if File.exists?('.gitignore') && File.read('.gitignore') !~ /.slapd/
          append_to_file('.gitignore', ".slapd\n")
        end
      end

    end
  end
end
