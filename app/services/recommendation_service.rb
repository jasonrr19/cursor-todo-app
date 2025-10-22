# frozen_string_literal: true

class RecommendationService
  # Scoring weights for different preference types
  GENRE_WEIGHT = 3.0
  LANGUAGE_WEIGHT = 5.0  # Increased to prioritize language matches
  COUNTRY_WEIGHT = 4.0   # Increased to prioritize country matches
  DECADE_WEIGHT = 1.0
  PEOPLE_WEIGHT = 2.5

  def initialize(user)
    @user = user
    @preferences = user.user_preference
  end

  def recommendations(limit: 20, exclude_reviewed: true, exclude_watched: true, serendipity_mode: nil)
    return [] unless @preferences

    # Start with all movies, excluding 0-vote movies (likely invalid/incomplete data)
    base_movies = Movie.includes(:genres, :production_country, :original_language, :people)
                       .where('vote_count > 0')
    
    # Try with strict filters first (language + country + genre)
    movies = apply_strict_filters(base_movies)
    
    # If no results, try relaxed filters (genre only, which is most important)
    if movies.empty? && @preferences.preferred_genre_ids.any?
      Rails.logger.info "No movies found with strict filters, falling back to genre-only for user #{@user.id}"
      movies = base_movies.joins(:genres)
                          .where(genres: { tmdb_id: @preferences.preferred_genre_ids })
                          .distinct
    end
    
    # If still no results, return popular movies in the selected genre (last resort)
    if movies.empty? && @preferences.preferred_genre_ids.any?
      Rails.logger.info "No movies found with genre filter, returning top popular genre movies for user #{@user.id}"
      movies = base_movies.joins(:genres)
                          .where(genres: { tmdb_id: @preferences.preferred_genre_ids })
                          .order(popularity: :desc, vote_average: :desc)
                          .distinct
    end
    
    # Exclude movies the user has already reviewed
    if exclude_reviewed
      reviewed_movie_ids = @user.reviews.pluck(:movie_id)
      movies = movies.where.not(id: reviewed_movie_ids) if reviewed_movie_ids.any?
    end

    # Exclude movies the user has already watched
    if exclude_watched
      watched_movie_ids = @user.watched_movies.pluck(:movie_id)
      movies = movies.where.not(id: watched_movie_ids) if watched_movie_ids.any?
    end

    # Apply serendipity filtering if requested
    if serendipity_mode
      movies = apply_serendipity_filter(movies, serendipity_mode)
    end

    # Get user's watched movies with positive reviews for boosting similar content
    positive_watched_movies = get_positive_watched_movies

    # Score and sort movies
    scored_movies = movies.map do |movie|
      {
        movie: movie,
        score: calculate_score(movie, serendipity_mode, positive_watched_movies)
      }
    end

    # Sort by score (descending) and return top results
    result_movies = scored_movies
      .sort_by { |item| -item[:score] }
      .first(limit)
      .map { |item| item[:movie] }

    # Track recommendation events
    track_recommendation_events(result_movies, serendipity_mode)

    result_movies
  end

  def serendipity_suggestions(limit: 5)
    return [] unless @preferences

    # Get both serendipity modes
    low_vote_movies = recommendations(limit: limit, serendipity_mode: 'low')
    obscure_movies = recommendations(limit: limit, serendipity_mode: 'obscure')
    
    # Combine and deduplicate
    all_movies = (low_vote_movies + obscure_movies).uniq
    all_movies.first(limit)
  end

  private

  def apply_strict_filters(base_movies)
    movies = base_movies
    
    # Filter by preferred genres if user has any preferences
    if @preferences.preferred_genre_ids.any?
      movies = movies.joins(:genres).where(genres: { tmdb_id: @preferences.preferred_genre_ids }).distinct
    end
    
    # Filter by preferred language if user has selected one
    if @preferences.preferred_language_codes.any?
      movies = movies.joins(:original_language)
                     .where(original_languages: { iso_639_1: @preferences.preferred_language_codes })
    end
    
    # Filter by preferred country if user has selected one
    if @preferences.preferred_country_codes.any?
      movies = movies.joins(:production_country)
                     .where(production_countries: { iso_3166_1: @preferences.preferred_country_codes })
    end
    
    movies
  end

  def apply_serendipity_filter(movies, mode)
    case mode
    when 'low'
      # Movies with low vote counts (bottom 30% by default)
      max_percentile = Rails.application.config.serendipity[:low_vote_max_percentile]
      threshold = calculate_vote_count_threshold(movies, max_percentile)
      movies.where('vote_count <= ?', threshold)
    when 'obscure'
      # Movies with both low popularity AND low vote counts (bottom 10% by default)
      max_percentile = Rails.application.config.serendipity[:obscure_max_percentile]
      vote_threshold = calculate_vote_count_threshold(movies, max_percentile)
      popularity_threshold = calculate_popularity_threshold(movies, max_percentile)
      movies.where('vote_count <= ? AND popularity <= ?', vote_threshold, popularity_threshold)
    else
      movies
    end
  end

  def calculate_vote_count_threshold(movies, percentile)
    # Calculate the vote count threshold for the given percentile
    vote_counts = movies.pluck(:vote_count).compact.sort
    return 0 if vote_counts.empty?
    
    index = (vote_counts.length * percentile / 100.0).ceil - 1
    index = [index, 0].max
    vote_counts[index]
  end

  def calculate_popularity_threshold(movies, percentile)
    # Calculate the popularity threshold for the given percentile
    popularities = movies.pluck(:popularity).compact.sort
    return 0 if popularities.empty?
    
    index = (popularities.length * percentile / 100.0).ceil - 1
    index = [index, 0].max
    popularities[index]
  end

  def calculate_score(movie, serendipity_mode = nil, positive_watched_movies = [])
    score = 0.0

    # Genre matching
    if @preferences.preferred_genre_ids.any?
      movie_genre_ids = movie.genres.pluck(:tmdb_id)
      matching_genres = @preferences.preferred_genre_ids & movie_genre_ids
      genre_score = matching_genres.length.to_f / @preferences.preferred_genre_ids.length
      score += genre_score * GENRE_WEIGHT
    end

    # Language matching
    if @preferences.preferred_language_codes.any?
      movie_language = movie.original_language&.iso_639_1
      if movie_language && @preferences.preferred_language_codes.include?(movie_language)
        score += LANGUAGE_WEIGHT
      end
    end

    # Country matching
    if @preferences.preferred_country_codes.any?
      movie_country = movie.production_country&.iso_3166_1
      if movie_country && @preferences.preferred_country_codes.include?(movie_country)
        score += COUNTRY_WEIGHT
      end
    end

    # Decade matching
    if @preferences.preferred_decade_strings.any?
      movie_decade = movie.decade
      if movie_decade && @preferences.preferred_decade_strings.include?(movie_decade)
        score += DECADE_WEIGHT
      end
    end

    # People matching (directors, actors, writers)
    if @preferences.preferred_person_ids.any?
      # preferred_people stores database IDs, so we need to get the actual Person records
      # and then compare with movie's people by database ID
      movie_person_ids = movie.people.pluck(:id)
      matching_people = @preferences.preferred_person_ids & movie_person_ids
      if matching_people.any?
        people_score = matching_people.length.to_f / @preferences.preferred_person_ids.length
        score += people_score * PEOPLE_WEIGHT
      end
    end

    # Boost score based on similarity to positively reviewed watched movies
    if positive_watched_movies.any?
      similarity_boost = calculate_similarity_to_watched(movie, positive_watched_movies)
      score += similarity_boost
    end

    # Serendipity bonus - give higher scores to obscure movies in serendipity mode
    if serendipity_mode
      # Boost score for movies with very low vote counts
      if movie.vote_count < 100
        score += 1.0
      elsif movie.vote_count < 500
        score += 0.5
      end
      
      # Boost score for movies with very low popularity
      if movie.popularity && movie.popularity < 1.0
        score += 0.5
      end
    else
      # Add popularity boost for tie-breaking in normal mode
      popularity_boost = Math.log([movie.vote_count, 1].max) * 0.1
      score += popularity_boost
    end

    score
  end

  def track_recommendation_events(movies, serendipity_mode = nil)
    return if movies.empty?

    context = {
      source: serendipity_mode ? 'serendipity' : 'recommendation',
      timestamp: Time.current.iso8601,
      movie_count: movies.length
    }

    if serendipity_mode
      context[:serendipity_mode] = serendipity_mode
      context[:serendipity_config] = {
        low_vote_max_percentile: Rails.application.config.serendipity[:low_vote_max_percentile],
        obscure_max_percentile: Rails.application.config.serendipity[:obscure_max_percentile]
      }
    end

    # Create impression events for each movie
    events = movies.map do |movie|
      {
        user_id: @user.id,
        movie_id: movie.id,
        event_type: 'impression',
        context: context,
        created_at: Time.current,
        updated_at: Time.current
      }
    end

    RecommendationEvent.insert_all(events)
  end

  # Get movies the user watched and rated positively (7+ rating)
  def get_positive_watched_movies
    @user.watched_movie_records
         .joins(:reviews)
         .where('reviews.user_id = ? AND reviews.rating >= ?', @user.id, 7)
         .includes(:genres, :people)
         .to_a
  end

  # Calculate similarity boost based on watched movies with positive reviews
  def calculate_similarity_to_watched(movie, positive_watched_movies)
    return 0.0 if positive_watched_movies.empty?

    max_similarity = 0.0
    movie_genre_ids = movie.genres.pluck(:tmdb_id)
    movie_person_ids = movie.people.pluck(:tmdb_id)

    positive_watched_movies.each do |watched_movie|
      similarity = 0.0

      # Genre overlap
      watched_genre_ids = watched_movie.genres.pluck(:tmdb_id)
      genre_overlap = (movie_genre_ids & watched_genre_ids).length
      if genre_overlap > 0 && watched_genre_ids.any?
        similarity += (genre_overlap.to_f / watched_genre_ids.length) * 1.5
      end

      # People overlap (directors, actors)
      watched_person_ids = watched_movie.people.pluck(:tmdb_id)
      people_overlap = (movie_person_ids & watched_person_ids).length
      if people_overlap > 0
        similarity += people_overlap * 1.0
      end

      # Same language
      if movie.original_language_id == watched_movie.original_language_id
        similarity += 0.5
      end

      # Same country
      if movie.production_country_id == watched_movie.production_country_id
        similarity += 0.3
      end

      max_similarity = [max_similarity, similarity].max
    end

    max_similarity
  end
end
