module Verver
  module SandboxedExecute

    def execute(instance_options={}, &safe_block)
      instance = new(instance_options)
      successful_install = instance.install!

      safe_block.call(instance) if successful_install
    ensure
      instance.uninstall! if successful_install
    end

  end
end
