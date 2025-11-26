# frozen_string_literal: true

module Dokku
  module Common
    
    def self.plugin_available_path      = ENV['PLUGIN_AVAILABLE_PATH']
    def self.plugin_core_available_path = ENV['PLUGIN_CORE_AVAILABLE_PATH']

    def self.inject_deps(deps, cmd) = `source #{deps} && #{cmd}`

    def self.property_function(fn, *args)
      inject_deps("property-functions", "#{fn} #{args.join(" ")}")
    end

    def self.property_get(*args)    = property_function("fn-plugin-property-get", *args)
    def self.property_delete(*args) = property_function("fn-plugin-property-delete", *args)
    def self.property_write(*args)  = property_function("fn-plugin-property-write", *args)

    def common = @common ||= Dokku::Common
  end
end