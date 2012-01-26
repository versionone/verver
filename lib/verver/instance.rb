require 'verver'
require 'verver/jenkins'

# An instance of the V1 app.
#
# app = Verver::Instance.new
# app.install(options)
# app.name
# app.database
# app.uninstall
#
# install an instance, run the block, uninstall the app.
# Verver::Instance.execute(installer_options) do |instance|
#
# end

module Verver
  class Instance

    def name
      "#{Jenkins.job_name}_#{Jenkins.build_number}"
    end

    def database_name
      name
    end

    def database_server
      "(local)"
    end

    def path
      "C:\\inetpub\\wwwroot\\#{name}"
    end

    def installer
      Dir.glob(File.join(Verver.root, "VersionOne.Setup-*.exe")).first
    end

    def license
      "VersionOne.Dev.lic"
    end

  end
end

