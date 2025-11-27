# frozen_string_literal: true

require_relative "./common"

module Dokku
  class Logger < ::Logger
    include Dokku::Common

    DOKKU_LOG_SEVERITY_MAP = {
      Logger::DEBUG => :dokku_log_verbose_quiet,
      Logger::INFO  => :dokku_log_info1_quiet,
      Logger::WARN  => :dokku_log_warn_quiet,
      Logger::ERROR => :dokku_log_exclaim_quiet,
      Logger::FATAL => :dokku_log_exclaim
    }

    def add(severity, message = nil, progname = nil)
      severity ||= Logger::UNKNOWN
      progname ||= @progname

      return true if severity < level

      if message.nil?
        if block_given?
          message = yield
        else
          message = progname
          progname = @progname
        end
      end

      formatted_message = "[#{progname}] #{message}"
      method_name       = DOKKU_LOG_SEVERITY_MAP.fetch(severity, :dokku_log_info1)

      common.public_send(method_name, formatted_message)
      common.dokku_log_stderr(formatted_message) if severity >= Logger::ERROR
    end
  end
end