# frozen_string_literal: true

# Cinema List Derby - TMDB Configuration

Rails.application.configure do
  # TMDB API Configuration
  config.tmdb = {
    api_key: ENV.fetch('TMDB_API_KEY', ''),
    base_url: ENV.fetch('TMDB_BASE_URL', 'https://api.themoviedb.org/3'),
    image_base_url: ENV.fetch('TMDB_IMAGE_BASE_URL', 'https://image.tmdb.org/t/p'),
    timeout: 10, # seconds
    retries: 3
  }

  # Serendipity Configuration
  config.serendipity = {
    enabled: ENV.fetch('ENABLE_SERENDIPITY_SUGGESTIONS', 'true') == 'true',
    low_vote_max_percentile: ENV.fetch('SERENDIPITY_LOW_VOTE_MAX_PERCENTILE', '40').to_i,
    obscure_max_percentile: ENV.fetch('SERENDIPITY_OBSCURE_MAX_PERCENTILE', '20').to_i
  }

  # Application Configuration
  config.app_name = ENV.fetch('APP_NAME', 'Cinema List Derby')
  config.app_url = ENV.fetch('APP_URL', 'http://localhost:3000')
end





