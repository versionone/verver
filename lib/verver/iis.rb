module Verver

  class IIS

    def initialize(shell_proc = Kernel.method(:system))
      @shell_proc = shell_proc
    end

    def reset
      @shell_proc.call('iisreset')
    end

    def stop
      @shell_proc.call('iisreset /stop')
    end

    def start
      @shell_proc.call('iisreset /start')
    end

  end

end
