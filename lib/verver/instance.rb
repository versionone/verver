require 'verver'
require 'verver/jenkins'
require 'verver/sandboxed_execute'

module Verver
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
  class Instance
    extend SandboxedExecute

    def initialize(options={})
      @options = options
    end

    def name
      @options.fetch(:name) { "#{Jenkins.job_name}_#{Jenkins.build_number}" }
    end

    def database_name
      @options.fetch(:database_name) { name }
    end

    def database_server
      @options.fetch(:database_server) { "(local)" }
    end

    def path
      @options.fetch(:path) { "C:\\inetpub\\wwwroot\\#{name}" }
    end

    def installer
      @options.fetch(:installer) { first_local_installer }
    end

    def license
      @options.fetch(:license) { first_local_license }
    end

    def install!
      command = "#{installer} -quiet -DBServer=#{database_server} -WebDir=#{path} #{name}"
      # Log the command about to be run? Perhaps use the Logging Gem?
      success = system(command)
      install_license(success)
      success
    end

    def uninstall!
      command = "#{installer} -U -quiet -DeleteDatabase #{name}"
      # Log the command about to be run? Perhaps use the Logging Gem?
      success = system(command)
    end

    private

    def first_local_installer
      first_local_file("VersionOne.Setup-*.exe")
    end

    def first_local_license
      first_local_file("VersionOne.Dev.lic")
    end

    def first_local_file(name)
      Dir.glob(File.join(Verver.root, name)).first
    end

    def install_license(install_succeeded)
      # consider either logging what we're about to do, or use :verbose => true option.
      FileUtils.copy(license, File.join(path, 'bin')) if install_succeeded and license
    end

  end
end

