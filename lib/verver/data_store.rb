module Verver
  module DataStore

    #test

    def self.server
      ENV['DB_SERVER'] || '.'
    end

    def self.db_name
      "#{Verver::Jenkins.job_name}_#{Verver::Jenkins.build_number}"
    end

    def self.user
      ENV['DB_SERVER_USER'] || 'pub'
    end

    def self.create_sql
      File.join(File.expand_path('..', __FILE__), %w[support create_db.sql])
    end

    def self.drop_sql
      File.join(File.expand_path('..', __FILE__), %w[support drop_db.sql])
    end

    def self.old_story(storyname, daysold, projectoid)
      file = File.join(File.expand_path('..', __FILE__), %w[support create_old_story.sql])
      if (Verver::Jenkins.job_name == 'local-job')
        servername = get_database_name_from_config()
      else
        servername = server
      end
      command = " sqlcmd.exe -i \"#{file}\" -s #{servername} -d #{db_name} -v DaysOld=#{daysold.to_s} ScopeOid=#{projectoid.delete("Scope:")} StoryName=\"#{storyname}\""
      puts(command)
      system(command)
    end

    def self.get_database_name_from_config
      connection_string = value_from_config("ConnectionString")
      values = connection_string.split("\;")
      value = (values.select {|item| item.starts_with?("Database")}).first
      return value.split("=")[1]
    end

    def self.value_from_config(key)
        user_config_file = File.join(ROOT, %W[VersionOne.Web user.config])
        web_config_file = File.join(ROOT, %W[VersionOne.Web web.config])
        value_from_config_file(user_config_file, key) or value_from_config_file(web_config_file, key)
    end

    def self.value_from_config_file(file, key)
        if FileTest.exists? file
          config = Nokogiri::XML(File.open file)
          config_node = config.css("appSettings add[key=#{key}]")
          if config_node.length > 0
            return config_node.attr('value').value
          end
        end
    end
  end

