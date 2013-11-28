require 'yaml'

module Slapd
  module CLI
    module Config
      def slapd_user
        'person'
      end

      def slapd_group
        'people'
      end

      def slapd_org
        'dc=example'
      end

      def slapd_tldc
        'dc=com'
      end

      def slapd_suffix
        [slapd_org, slapd_tldc].join(',')
      end

      def slapd_given_name
        'Given'
      end

      def slapd_surname
        'Surname'
      end

      def slapd_password
        '{SSHA}pdxyvdSlZqQx866wzjHW6PAJBBA56E6B'
      end

      def slapd_admin
        'admin'
      end

      def slapd_root
        # Get the current working directory.
        File.expand_path('./.slapd')
      end

      def slapd_port
        '9009'
      end
    end
  end
end
