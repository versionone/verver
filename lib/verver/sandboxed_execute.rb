module Verver
  module SandboxedExecute

    def execute(install_options={}, &safe_block)
      instance = new(install_options)
      return unless instance.install!

      __execute_in_sandbox(instance, safe_block)
    end

    private

    def __execute_in_sandbox(instance, safe_block)
      safe_block.call(instance)
    ensure
      instance.uninstall!
    end

  end
end
