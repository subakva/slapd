namespace :slapd do
  def execute(commands)
    commands.each do |command|
      puts "$ #{command[:cmd]}"
      system(command[:cmd])
      puts
      allow_failure = command[:allow_failure].nil? ? false : command[:allow_failure]
      return unless $?.success? || allow_failure
    end
  end

  def connection_args
    %{-D "cn=admin,dc=example,dc=com" -w password -H "ldap://127.0.0.1:9009"}
  end

  task :_ensure_development => :environment do
    # TODO: Do not tie this to Rails.
    raise "This task is only meant to be run in development." unless Rails.env.development?
  end

  task :_remove_db => :_ensure_development do
    execute([
      {:cmd => %{rm -rf ./.slapd/openldap-data/*}}
    ])
  end

  task :_create_users => :_ensure_development do
    execute([
      {:cmd => %{/usr/bin/ldapadd #{connection_args} -f config/slapd/groups.ldif}},
      {:cmd => %{/usr/bin/ldapadd #{connection_args} -f config/slapd/person.ldif}},
    ])
  end

  task :_copy_config => :_ensure_development do
    execute([
      {:cmd => %{cp -f config/slapd/slapd.conf config/slapd/slapd.conf}}
    ])
  end

  desc 'Starts the OpenLDAP server.'
  task :start => :_ensure_development do
    execute([
      {:cmd => %{/usr/libexec/slapd -h "ldap://127.0.0.1:9009"}}
    ])
  end

  desc 'Starts the OpenLDAP server.'
  task :debug => :_ensure_development do
    execute([
      {:cmd => %{/usr/libexec/slapd -h "ldap://127.0.0.1:9009" -d 1}}
    ])
  end

  desc 'Stops the OpenLDAP server.'
  task :stop => :_ensure_development do
    # TODO: Read the pid file from .slapd
    execute([
      {:cmd => %{ps aux | grep [s]lapd | awk '{print $2}' | xargs kill}}
    ])
  end

  desc "Runs a test search to ensure that the LDAP server is up and configured."
  task :check => :_ensure_development do
    execute([
      {:cmd => %{/usr/bin/ldapsearch #{connection_args} -b "ou=people,dc=example,dc=com" 'uid=person'}}
    ])
  end

  desc "Stops and starts the OpenLDAP server."
  task :restart => [:stop, :start]

  desc "Completely clears and rebuilds the OpenLDAP server. This will destroy ALL data in the server."
  task :reset => [:stop, :_remove_db, :_copy_config, :start, :_create_users]

  desc "Configures, starts and loads data into the OpenLDAP server."
  task :configure => [:_copy_config, :restart, :_create_users]
end
