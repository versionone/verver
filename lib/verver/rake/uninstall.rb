require 'rake'
require 'rake/tasklib'

module Verver
  module Rake

    class Uninstall < ::Rake::TaskLib

      include ::Rake::DSL if defined?(::Rake::DSL)
      attr_accessor :setup_exe, :instance, :server, :fail_on_error, :verbose

      def initialize(*args)
        name = args.shift || :uninstall
        yield self if block_given?

        desc("install executable") unless ::Rake.application.last_comment
        task name do
          begin
            command = "#{setup_exe} -U -quiet -DBServer=#{server} -DeleteDatabase #{instance}"
            puts command if verbose
            success = system(command)
          rescue
            puts 'failure'
          end
          fail("#{command} failed") if fail_on_error unless success
        end
      end

    end

  end
end

