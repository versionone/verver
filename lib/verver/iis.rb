require 'verver'
require 'verver/iis/app_pool'
require 'verver/iis/automation'
require 'verver/iis/components'

module Verver
  module IIS

    class ComponentNotInstalled < Verver::Error; end

    def self.ensure_management_scripting_tools_installed!(components=Components.new)
      installed = components.installed?(:management_scripting_tools)
      fail(ComponentNotInstalled) unless installed
    end

  end
end

#Verver::IIS::ensure_management_scripting_tools_installed! if Verver.production?
