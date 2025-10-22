# frozen_string_literal: true

class MovieSearchService
  def initialize(user = nil)
    @user = user
    @tmdb_client = TmdbClient.new
  end

  def search(query, filters = {}, page: 1)
    Rails.logger.info "Searching for movies: '#{query}' with filters: #{filters}, page: #{page}"

    # If people filter is specified, search by people first
    if filters[:people].present? && filters[:people].any?
      return search_by_people(filters[:people], filters, page: page)
    end

    # Set up TMDB filters (don't use year filter for decades)
    tmdb_filters = {}
    tmdb_filters[:genre] = filters[:genre] if filters[:genre].present?
    
    # Only use TMDB year filter for specific years, not decades
    if filters[:year].present? && !filters[:year].end_with?('s')
      tmdb_filters[:year] = filters[:year].to_i
    end

    # Search TMDB API with pagination
    tmdb_results = @tmdb_client.search_movies(
      query,
      page: page,
      year: tmdb_filters[:year],
      genre: tmdb_filters[:genre]
    )
    return { success: false, error: 'No results from TMDB' } if tmdb_results['results'].blank?

    # Process results and hydrate missing movies
    results = []
    tmdb_results['results'].each do |movie_data|
      movie = find_or_hydrate_movie(movie_data['id'])
      next unless movie

      # Apply all filters
      next unless passes_filters?(movie, filters)

      relevance_score = calculate_relevance_score(movie, query)
      # Skip movies with 0 votes (relevance_score will be -1000 for these)
      next if relevance_score < 0

      results << format_movie_result(movie).merge(relevance_score: relevance_score)
    end

    # Sort by relevance (exact title matches first, then by popularity)
    results.sort_by! { |r| [-r[:relevance_score], -r[:vote_count].to_i] }
    results.each { |r| r.delete(:relevance_score) } # Remove internal scoring field

    # Log search query for analytics (works with or without user)
    log_search_query(query, filters, results.count) if page == 1

    { success: true, results: results, total_pages: tmdb_results['total_pages'], current_page: page }
  rescue TmdbClientError => e
    Rails.logger.error "TMDB search error: #{e.message}"
    { success: false, error: e.message }
  rescue => e
    Rails.logger.error "Unexpected search error: #{e.message}"
    { success: false, error: 'Search failed' }
  end

  def get_movie_details(tmdb_id)
    movie = Movie.find_by(tmdb_id: tmdb_id)
    return { success: false, error: 'Movie not found' } unless movie

    # Ensure movie is fully hydrated with credits
    hydrate_movie_credits(movie) unless movie.people.any?

    {
      success: true,
      movie: {
        id: movie.id,
        tmdb_id: movie.tmdb_id,
        title: movie.title,
        overview: movie.overview,
        release_date: movie.release_date,
        vote_average: movie.vote_average,
        vote_count: movie.vote_count,
        poster_path: movie.poster_path,
        backdrop_path: movie.backdrop_path,
        runtime: movie.runtime,
        genres: movie.genres.map { |g| { id: g.tmdb_id, name: g.name } },
        production_country: {
          iso_3166_1: movie.production_country.iso_3166_1,
          name: movie.production_country.name
        },
        original_language: {
          iso_639_1: movie.original_language.iso_639_1,
          name: movie.original_language.name
        },
        people: movie.people.map do |person|
          {
            id: person.tmdb_id,
            name: person.name,
            known_for_department: person.known_for_department,
            profile_path: person.profile_path,
            job: person.movie_people.find_by(movie: movie)&.job
          }
        end
      }
    }
  end

  def search_people(query, limit = 10)
    Rails.logger.info "Searching for people: '#{query}'"
    
    # Search TMDB for people
    tmdb_results = @tmdb_client.search_people(query, page: 1)
    return { success: false, error: 'No results from TMDB' } if tmdb_results['results'].blank?

    # Process and cache results
    results = []
    tmdb_results['results'].first(limit).each do |person_data|
      person = find_or_create_person(person_data)
      next unless person

      results << {
        id: person.id,
        tmdb_id: person.tmdb_id,
        name: person.name,
        known_for_department: person.known_for_department,
        profile_path: person.profile_path
      }
    end

    { success: true, results: results }
  rescue TmdbClientError => e
    Rails.logger.error "TMDB people search error: #{e.message}"
    { success: false, error: e.message }
  rescue => e
    Rails.logger.error "Unexpected people search error: #{e.message}"
    { success: false, error: 'People search failed' }
  end

  private

  def search_by_people(person_ids, filters = {}, page: 1)
    Rails.logger.info "Searching movies by people: #{person_ids}, page: #{page}"
    
    per_page = 20
    offset = (page - 1) * per_page
    
    # Find movies that have any of the specified people
    movies_query = Movie.joins(:people)
                  .where(people: { tmdb_id: person_ids })
                  .distinct
                  .includes(:genres, :production_country, :original_language, :people)

    # Get total count for pagination
    total_count = movies_query.count
    total_pages = (total_count.to_f / per_page).ceil

    # Apply pagination
    movies = movies_query.offset(offset).limit(per_page)

    # Apply additional filters
    results = []
    movies.each do |movie|
      next unless passes_filters?(movie, filters)
      # Skip movies with 0 votes
      next if movie.vote_count.nil? || movie.vote_count == 0
      results << format_movie_result(movie)
    end

    # Sort by popularity/vote count
    results.sort_by! { |movie| [-movie[:vote_average].to_f, -movie[:vote_count].to_i] }

    # Log search query for analytics (only for first page)
    log_search_query("Search by people: #{person_ids.join(',')}", filters, results.count) if page == 1

    { success: true, results: results, total_pages: total_pages, current_page: page }
  end

  def passes_filters?(movie, filters)
    # Decade filtering
    if filters[:year].present? && filters[:year].end_with?('s')
      movie_year = movie.release_date&.year
      return false unless movie_year && movie_in_decade?(movie_year, filters[:year])
    end

    # Language filtering
    if filters[:language].present?
      movie_language_code = movie.original_language&.iso_639_1
      return false unless movie_language_code == filters[:language]
    end

    # Country filtering
    if filters[:country].present?
      movie_country_code = movie.production_country&.iso_3166_1
      return false unless movie_country_code == filters[:country]
    end

    # Genre filtering (if not already handled by TMDB)
    if filters[:genre].present?
      movie_genre_ids = movie.genres.pluck(:tmdb_id)
      return false unless movie_genre_ids.include?(filters[:genre].to_i)
    end

    true
  end

  def format_movie_result(movie)
    {
      id: movie.id,
      tmdb_id: movie.tmdb_id,
      title: movie.title,
      overview: movie.overview,
      release_date: movie.release_date,
      vote_average: movie.vote_average,
      vote_count: movie.vote_count,
      poster_path: movie.poster_path,
      backdrop_path: movie.backdrop_path,
      runtime: movie.runtime,
      genres: movie.genres.pluck(:name),
      production_country: movie.production_country.name,
      original_language: movie.original_language.name,
      watched: @user ? @user.watched?(movie) : false,
      people: movie.people.limit(5).map do |person|
        {
          id: person.tmdb_id,
          name: person.name,
          known_for_department: person.known_for_department,
          job: person.movie_people.find_by(movie: movie)&.job
        }
      end
    }
  end

  def find_or_create_person(person_data)
    person = Person.find_by(tmdb_id: person_data['id'])
    return person if person

    Person.create!(
      tmdb_id: person_data['id'],
      name: person_data['name'],
      known_for_department: person_data['known_for_department'],
      profile_path: person_data['profile_path']
    )
  rescue => e
    Rails.logger.error "Failed to create person #{person_data['name']}: #{e.message}"
    nil
  end

  def movie_in_decade?(year, decade)
    case decade
    when '2020s'
      year >= 2020 && year <= 2029
    when '2010s'
      year >= 2010 && year <= 2019
    when '2000s'
      year >= 2000 && year <= 2009
    when '1990s'
      year >= 1990 && year <= 1999
    when '1980s'
      year >= 1980 && year <= 1989
    when '1970s'
      year >= 1970 && year <= 1979
    when '1960s'
      year >= 1960 && year <= 1969
    when '1950s'
      year >= 1950 && year <= 1959
    when '1940s'
      year >= 1940 && year <= 1949
    when '1930s'
      year >= 1930 && year <= 1939
    when '1920s'
      year >= 1920 && year <= 1929
    else
      false
    end
  end

  def find_or_hydrate_movie(tmdb_id)
    # Check if movie exists in our database
    movie = Movie.find_by(tmdb_id: tmdb_id)
    return movie if movie

    # Hydrate movie from TMDB
    seeder = TmdbSeederService.new
    result = seeder.hydrate_movie(tmdb_id)
    result[:success] ? result[:movie] : nil
  end

  def hydrate_movie_credits(movie)
    Rails.logger.info "Hydrating credits for movie: #{movie.title}"

    begin
      credits = @tmdb_client.fetch_credits(movie.tmdb_id)
      
      # Add crew members (directors, writers)
      if credits['crew']
        credits['crew'].each do |person_data|
          next unless person_data['job']&.in?(%w[Director Writer])

          person = Person.find_or_create_by(tmdb_id: person_data['id']) do |p|
            p.name = person_data['name']
            p.known_for_department = person_data['known_for_department']
            p.profile_path = person_data['profile_path']
          end

          MoviePerson.find_or_create_by(
            movie: movie,
            person: person,
            job: person_data['job']
          )
        end
      end

      # Add cast members (actors)
      if credits['cast']
        credits['cast'].first(10).each do |person_data| # Limit to top 10 cast
          person = Person.find_or_create_by(tmdb_id: person_data['id']) do |p|
            p.name = person_data['name']
            p.known_for_department = person_data['known_for_department'] || 'Acting'
            p.profile_path = person_data['profile_path']
          end

          MoviePerson.find_or_create_by(
            movie: movie,
            person: person,
            job: 'Actor'
          )
        end
      end

      Rails.logger.info "Successfully hydrated credits for: #{movie.title}"
    rescue TmdbClientError => e
      Rails.logger.error "Failed to hydrate credits for #{movie.title}: #{e.message}"
    end
  end

  def log_search_query(query, filters, results_count)
    SearchQuery.create!(
      user: @user,
      query: query,
      filters: filters.to_json,
      results_count: results_count
    )
  rescue => e
    Rails.logger.error "Failed to log search query: #{e.message}"
  end

  # Calculate relevance score for search results
  # Higher scores = more relevant
  def calculate_relevance_score(movie, query)
    # Filter out movies with 0 votes (likely unreleased or data quality issues)
    return -1000 if movie.vote_count.nil? || movie.vote_count == 0
    
    score = 0
    query_normalized = query.downcase.strip
    title_normalized = movie.title.downcase.strip

    # Exact match (highest priority)
    if title_normalized == query_normalized
      score += 1000
    # Title starts with query (high priority for franchises like "Superman", "Batman")
    elsif title_normalized.start_with?(query_normalized)
      score += 500
    # Title contains query as a word
    elsif title_normalized.include?(" #{query_normalized} ") || 
          title_normalized.start_with?("#{query_normalized} ") ||
          title_normalized.end_with?(" #{query_normalized}")
      score += 250
    # Title contains query substring
    elsif title_normalized.include?(query_normalized)
      score += 100
    end

    # Bonus for popularity (scaled down to not override relevance)
    score += (movie.popularity || 0) / 100.0
    
    # Bonus for vote count (indicates more established/official films)
    score += movie.vote_count / 1000.0

    score
  end
end
