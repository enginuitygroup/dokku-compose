# frozen_string_literal: true

module Dokku
  module Common
    
    def self.plugin_available_path      = ENV['PLUGIN_AVAILABLE_PATH']
    def self.plugin_core_available_path = ENV['PLUGIN_CORE_AVAILABLE_PATH']

    def self.inject_deps(deps, cmd, *args) = `bash -c 'source #{plugin_core_available_path}/#{deps} && #{cmd} #{args.join(" ")}'`

    ################################################################################
    # Property functions
    ################################################################################
    def self.property_function(fn, *args)
      inject_deps("property-functions", fn, *args)
    end

    def self.property_get(*args)    = property_function("fn-plugin-property-get", *args)
    def self.property_delete(*args) = property_function("fn-plugin-property-delete", *args)
    def self.property_write(*args)  = property_function("fn-plugin-property-write", *args)

    ################################################################################
    # Log functions
    ################################################################################
    def self.log_function(fn, *args) = inject_deps("functions", fn, *args)

    def self.dokku_log_quiet(*args)       = log_function("dokku_log_quiet", *args)
    def self.dokku_log_info1(*args)       = log_function("dokku_log_info1", *args)
    def self.dokku_log_info1_quiet(*args) = log_function("dokku_log_info1_quiet", *args)
    def self.dokku_log_info2(*args)       = log_function("dokku_log_info2", *args)
    def self.dokku_log_info2_quiet(*args) = log_function("dokku_log_info2_quiet", *args)      

    def self.dokku_col_log_info1(*args)       = log_function("dokku_col_log_info1", *args)
    def self.dokku_col_log_info1_quiet(*args) = log_function("dokku_col_log_info1_quiet", *args)
    def self.dokku_col_log_info2(*args)       = log_function("dokku_col_log_info2", *args)
    def self.dokku_col_log_info2_quiet(*args) = log_function("dokku_col_log_info2_quiet", *args)
    def self.dokku_col_log_msg(*args)         = log_function("dokku_col_log_msg", *args)
    def self.dokku_col_log_msg_quiet(*args)   = log_function("dokku_col_log_msg_quiet", *args)
    
    def self.dokku_log_verbose(*args)       = log_function("dokku_log_verbose", *args)
    def self.dokku_log_verbose_quiet(*args) = log_function("dokku_log_verbose_quiet", *args)
    def self.dokku_log_exclaim(*args)       = log_function("dokku_log_exclaim", *args)
    def self.dokku_log_exclaim_quiet(*args) = log_function("dokku_log_exclaim_quiet", *args)
    def self.dokku_log_warn(*args)          = log_function("dokku_log_warn", *args)
    def self.dokku_log_warn_quiet(*args)    = log_function("dokku_log_warn_quiet", *args)
    def self.dokku_log_exit(*args)          = log_function("dokku_log_exit", *args)
    def self.dokku_log_exit_quiet(*args)    = log_function("dokku_log_exit_quiet", *args)
    def self.dokku_log_fail(*args)          = log_function("dokku_log_fail", *args)
    def self.dokku_log_fail_quiet(*args)    = log_function("dokku_log_fail_quiet", *args)

    def self.dokku_log_stderr(*args) = log_function("dokku_log_stderr", *args)

    def common = @common ||= Dokku::Common
  end
end