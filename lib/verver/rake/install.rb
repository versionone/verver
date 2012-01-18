require 'rake'
require 'rake/tasklib'

module Verver
  module Rake

    class Install < ::Rake::TaskLib
      include ::Rake::DSL if defined?(::Rake::DSL)
      attr_accessor :setup_exe, :instance, :instance_path, :license_file, :server, :fail_on_error, :verbose, :attempt_uninstall_first

      def initialize(*args)
        name = args.shift || :install
        yield self if block_given?

        desc("install executable") unless ::Rake.application.last_comment
        task name do
          begin
            command = "#{setup_exe} -quiet -DBServer=#{server} -WebDir=#{instance_path} #{instance}"
            puts command if verbose
            success = system(command)

            cp license_file, File.join(instance_path, 'bin'), :verbose => true if license_file
          rescue
            puts 'failure'
          end
          fail("#{command} failed") if fail_on_error unless success
        end
      end

    end

  end
end
