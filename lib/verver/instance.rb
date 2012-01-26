require 'verver'
require 'verver/jenkins'

# An instance of the V1 app.
#
# app = Verver::Instance.new(options)
# app.install!
# app.name
# app.database
# app.uninstall!
#
# install an instance, run the block, uninstall the app.
# Verver::Instance.execute(installer_options) do |instance|
#   # ...
# end
#
# app = Verver::Instance.install(options)
# Verver::Instance.uninstall(options)

module Verver
  class Instance

    def initialize(options={})
      @options = options
    end

    def name
      @options.fetch(:name) { "#{Jenkins.job_name}_#{Jenkins.build_number}" }
    end

    def database_name
      name
    end

    def database_server
      "(local)"
    end

    def path
      @options.fetch(:path) { "C:\\inetpub\\wwwroot\\#{name}" }
    end

    def installer
      Dir.glob(File.join(Verver.root, "VersionOne.Setup-*.exe")).first
    end

    def license
      "VersionOne.Dev.lic"
    end

    def install!
      command = "#{installer} -quiet -DBServer=#{database_server} -WebDir=#{path} #{name}"
      system(command)
    end

  end
end

