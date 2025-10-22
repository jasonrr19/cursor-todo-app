# frozen_string_literal: true

class TmdbClient
  include HTTParty

  base_uri Rails.application.config.tmdb[:base_url]
  default_timeout Rails.application.config.tmdb[:timeout]
  format :json

  def initialize
    @api_key = Rails.application.config.tmdb[:api_key]
    @retries = Rails.application.config.tmdb[:retries]
  end

  # Fetch all available genres
  def fetch_genres
    get_request('/genre/movie/list')
  end

  # Fetch movie details by TMDB ID
  def fetch_movie_details(tmdb_id)
    get_request("/movie/#{tmdb_id}")
  end

  # Fetch movie credits by TMDB ID
  def fetch_credits(tmdb_id)
    get_request("/movie/#{tmdb_id}/credits")
  end

  # Search movies by query
  def search_movies(query, page: 1, year: nil, genre: nil)
    params = {
      query: query,
      page: page,
      include_adult: false
    }
    params[:year] = year if year
    params[:with_genres] = genre if genre

    get_request('/search/movie', params)
  end

  # Search people (directors/crew) by query
  def search_people(query, page: 1)
    params = {
      query: query,
      page: page,
      include_adult: false
    }

    get_request('/search/person', params)
  end

  # Get popular movies
  def fetch_popular_movies(page: 1)
    get_request('/movie/popular', { page: page })
  end

  # Get top rated movies
  def fetch_top_rated_movies(page: 1)
    get_request('/movie/top_rated', { page: page })
  end

  # Get movies by genre
  def fetch_movies_by_genre(genre_id, page: 1)
    get_request('/discover/movie', {
      with_genres: genre_id,
      page: page,
      sort_by: 'popularity.desc'
    })
  end

  # Get movies by decade
  def fetch_movies_by_decade(decade, page: 1)
    start_year = decade.to_i
    end_year = start_year + 9

    get_request('/discover/movie', {
      'primary_release_date.gte' => "#{start_year}-01-01",
      'primary_release_date.lte' => "#{end_year}-12-31",
      page: page,
      sort_by: 'popularity.desc'
    })
  end

  # Get movies by country
  def fetch_movies_by_country(country_code, page: 1)
    get_request('/discover/movie', {
      with_origin_country: country_code,
      page: page,
      sort_by: 'popularity.desc'
    })
  end

  # Get movies by language
  def fetch_movies_by_language(language_code, page: 1)
    get_request('/discover/movie', {
      with_original_language: language_code,
      page: page,
      sort_by: 'popularity.desc'
    })
  end

  # Get person details by TMDB ID
  def fetch_person_details(tmdb_id)
    get_request("/person/#{tmdb_id}")
  end

  # Get person's movie credits
  def fetch_person_movie_credits(tmdb_id)
    get_request("/person/#{tmdb_id}/movie_credits")
  end

  private

  def get_request(endpoint, params = {})
    with_retries do
      response = self.class.get(endpoint, query: default_params.merge(params))
      handle_response(response)
    end
  end

  def default_params
    {
      api_key: @api_key,
      language: 'en-US'
    }
  end

  def with_retries
    retries = 0
    begin
      yield
    rescue Timeout::Error, Errno::ECONNRESET, Errno::ECONNREFUSED => e
      retries += 1
      if retries <= @retries
        sleep(2 ** retries) # Exponential backoff
        retry
      else
        raise TmdbClientError, "Request failed after #{@retries} retries: #{e.message}"
      end
    end
  end

  def handle_response(response)
    case response.code
    when 200
      response.parsed_response
    when 401
      raise TmdbClientError, 'Invalid API key'
    when 404
      raise TmdbClientError, 'Resource not found'
    when 429
      raise TmdbClientError, 'Rate limit exceeded'
    when 500..599
      raise TmdbClientError, "TMDB server error: #{response.code}"
    else
      raise TmdbClientError, "Unexpected response: #{response.code}"
    end
  end
end

# Custom error class for TMDB client
class TmdbClientError < StandardError; end
