# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.configure do
  config.eager_load = false
  config.cache_classes = false
  config.action_controller.perform_caching = false
  config.action_controller.enable_fragment_cache_logging = true
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true
  config.active_support.disallowed_deprecation = :raise
  config.active_support.disallowed_deprecation_warnings = []
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
  config.active_record.dump_schema_after_migration = false
end





