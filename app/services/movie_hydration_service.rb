# frozen_string_literal: true

class MovieHydrationService
  def initialize
    @tmdb_client = TmdbClient.new
  end

  # Queue a job to fetch credits for a movie
  def queue_credits_fetch(movie_id)
    MovieCreditsJob.perform_later(movie_id)
  end

  # Queue jobs for multiple movies
  def queue_bulk_credits_fetch(movie_ids)
    movie_ids.each do |movie_id|
      queue_credits_fetch(movie_id)
    end
  end

  # Queue credits fetch for all movies that don't have credits yet
  def queue_missing_credits
    movies_without_credits = Movie.left_joins(:people)
                                 .where(movie_people: { id: nil })
                                 .limit(100) # Process in batches

    Rails.logger.info "Queueing credits fetch for #{movies_without_credits.count} movies"
    
    movies_without_credits.each do |movie|
      queue_credits_fetch(movie.id)
    end

    movies_without_credits.count
  end

  # Queue credits fetch for movies with low credit count (incomplete data)
  def queue_incomplete_credits(min_credits: 5)
    movies_with_few_credits = Movie.joins(:people)
                                  .group('movies.id')
                                  .having('COUNT(movie_people.id) < ?', min_credits)
                                  .limit(50)

    Rails.logger.info "Queueing credits fetch for #{movies_with_few_credits.count} movies with incomplete credits"
    
    count = 0
    movies_with_few_credits.each do |movie|
      queue_credits_fetch(movie.id)
      count += 1
    end

    count
  end

  # Get hydration status for a movie
  def movie_hydration_status(movie_id)
    movie = Movie.find(movie_id)
    
    {
      movie_id: movie.id,
      title: movie.title,
      has_credits: movie.people.any?,
      credits_count: movie.people.count,
      crew_count: movie.people.joins(:movie_people)
                        .where(movie_people: { job: %w[Director Writer Producer Cinematographer Editor Composer] })
                        .count,
      cast_count: movie.people.joins(:movie_people)
                      .where(movie_people: { job: 'Actor' })
                      .count,
      last_updated: movie.updated_at
    }
  end

  # Get overall hydration status
  def overall_hydration_status
    total_movies = Movie.count
    movies_with_credits = Movie.joins(:people).distinct.count
    movies_without_credits = total_movies - movies_with_credits

    {
      total_movies: total_movies,
      movies_with_credits: movies_with_credits,
      movies_without_credits: movies_without_credits,
      hydration_percentage: total_movies > 0 ? (movies_with_credits.to_f / total_movies * 100).round(2) : 0,
      total_people: Person.count,
      total_credits: MoviePerson.count
    }
  end

  # Clean up orphaned movie-people relationships
  def cleanup_orphaned_relationships
    orphaned_count = MoviePerson.left_joins(:movie, :person)
                               .where(movies: { id: nil })
                               .or(MoviePerson.left_joins(:movie, :person)
                                             .where(people: { id: nil }))
                               .count

    if orphaned_count > 0
      Rails.logger.info "Cleaning up #{orphaned_count} orphaned movie-people relationships"
      MoviePerson.left_joins(:movie, :person)
                 .where(movies: { id: nil })
                 .or(MoviePerson.left_joins(:movie, :person)
                               .where(people: { id: nil }))
                 .delete_all
    end

    orphaned_count
  end
end
