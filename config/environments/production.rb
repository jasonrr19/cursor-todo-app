# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.configure do
  config.eager_load = true
  config.cache_classes = true
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?
  config.active_support.deprecation = :notify
  config.active_support.disallowed_deprecation = :log
  config.active_support.disallowed_deprecation_warnings = []
  config.active_record.dump_schema_after_migration = false
  
  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local
end





