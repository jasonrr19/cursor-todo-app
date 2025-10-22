# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.configure do
  config.eager_load = false
  config.cache_classes = true
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => "public, max-age=#{1.hour.to_i}"
  }
  config.active_support.deprecation = :stderr
  config.active_support.disallowed_deprecation = :raise
  config.active_support.disallowed_deprecation_warnings = []
  config.active_record.dump_schema_after_migration = false
end





