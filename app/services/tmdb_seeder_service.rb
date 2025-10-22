# frozen_string_literal: true

class TmdbSeederService
  def initialize
    @client = TmdbClient.new
  end

  def seed_genres
    Rails.logger.info "Starting genre seeding from TMDB..."
    
    begin
      response = @client.fetch_genres
      genres_data = response['genres'] || []
      
      genres_data.each do |genre_data|
        Genre.find_or_create_by(tmdb_id: genre_data['id']) do |genre|
          genre.name = genre_data['name']
        end
      end
      
      Rails.logger.info "Successfully seeded #{genres_data.count} genres"
      { success: true, count: genres_data.count }
    rescue TmdbClientError => e
      Rails.logger.error "Failed to seed genres: #{e.message}"
      { success: false, error: e.message }
    end
  end

  def seed_production_countries
    Rails.logger.info "Starting production countries seeding..."
    
    # Common production countries for our demo
    countries_data = [
      { name: 'United States of America', iso_3166_1: 'US' },
      { name: 'Japan', iso_3166_1: 'JP' },
      { name: 'South Korea', iso_3166_1: 'KR' },
      { name: 'United Kingdom', iso_3166_1: 'GB' },
      { name: 'France', iso_3166_1: 'FR' },
      { name: 'Germany', iso_3166_1: 'DE' },
      { name: 'Italy', iso_3166_1: 'IT' },
      { name: 'Spain', iso_3166_1: 'ES' },
      { name: 'Canada', iso_3166_1: 'CA' },
      { name: 'Australia', iso_3166_1: 'AU' }
    ]
    
    countries_data.each do |country_data|
      ProductionCountry.find_or_create_by(iso_3166_1: country_data[:iso_3166_1]) do |country|
        country.name = country_data[:name]
      end
    end
    
    Rails.logger.info "Successfully seeded #{countries_data.count} production countries"
    { success: true, count: countries_data.count }
  end

  def seed_original_languages
    Rails.logger.info "Starting original languages seeding..."
    
    # Common languages for our demo
    languages_data = [
      { name: 'English', iso_639_1: 'en' },
      { name: 'Japanese', iso_639_1: 'ja' },
      { name: 'Korean', iso_639_1: 'ko' },
      { name: 'French', iso_639_1: 'fr' },
      { name: 'German', iso_639_1: 'de' },
      { name: 'Italian', iso_639_1: 'it' },
      { name: 'Spanish', iso_639_1: 'es' },
      { name: 'Chinese', iso_639_1: 'zh' },
      { name: 'Russian', iso_639_1: 'ru' },
      { name: 'Portuguese', iso_639_1: 'pt' }
    ]
    
    languages_data.each do |language_data|
      OriginalLanguage.find_or_create_by(iso_639_1: language_data[:iso_639_1]) do |language|
        language.name = language_data[:name]
      end
    end
    
    Rails.logger.info "Successfully seeded #{languages_data.count} original languages"
    { success: true, count: languages_data.count }
  end

  def seed_demo_movies
    Rails.logger.info "Starting demo movies seeding (J-Horror 2000s)..."
    
    # J-Horror movies from the 2000s for our demo
    demo_movies = [
      { tmdb_id: 1452, title: 'The Grudge' },
      { tmdb_id: 1453, title: 'The Ring' },
      { tmdb_id: 1454, title: 'Dark Water' },
      { tmdb_id: 1455, title: 'Pulse' },
      { tmdb_id: 1456, title: 'One Missed Call' }
    ]
    
    seeded_count = 0
    
    demo_movies.each do |movie_data|
      next if Movie.exists?(tmdb_id: movie_data[:tmdb_id])
      
      begin
        movie_details = @client.fetch_movie_details(movie_data[:tmdb_id])
        movie_credits = @client.fetch_credits(movie_data[:tmdb_id])
        
        # Find or create production country
        country_code = movie_details['production_countries']&.first&.dig('iso_3166_1') || 'JP'
        country = ProductionCountry.find_by(iso_3166_1: country_code) || ProductionCountry.first
        
        # Find or create original language
        language_code = movie_details['original_language'] || 'ja'
        language = OriginalLanguage.find_by(iso_639_1: language_code) || OriginalLanguage.first
        
        # Create movie
        movie = Movie.create!(
          tmdb_id: movie_details['id'],
          title: movie_details['title'],
          overview: movie_details['overview'],
          release_date: movie_details['release_date'] ? Date.parse(movie_details['release_date']) : nil,
          vote_average: movie_details['vote_average'] || 0,
          vote_count: movie_details['vote_count'] || 0,
          poster_path: movie_details['poster_path'],
          backdrop_path: movie_details['backdrop_path'],
          runtime: movie_details['runtime'],
          production_country: country,
          original_language: language
        )
        
        # Add genres
        if movie_details['genres']
          movie_details['genres'].each do |genre_data|
            genre = Genre.find_by(tmdb_id: genre_data['id'])
            movie.genres << genre if genre
          end
        end
        
        # Add people (directors, actors, writers)
        if movie_credits['crew']
          movie_credits['crew'].each do |person_data|
            next unless person_data['job']&.in?(%w[Director Writer])
            
            person = Person.find_or_create_by(tmdb_id: person_data['id']) do |p|
              p.name = person_data['name']
              p.known_for_department = person_data['known_for_department']
              p.profile_path = person_data['profile_path']
            end
            
            MoviePerson.create!(
              movie: movie,
              person: person,
              job: person_data['job']
            )
          end
        end
        
        seeded_count += 1
        Rails.logger.info "Seeded movie: #{movie.title}"
        
      rescue => e
        Rails.logger.error "Failed to seed movie #{movie_data[:title]}: #{e.message}"
      end
    end
    
    Rails.logger.info "Successfully seeded #{seeded_count} demo movies"
    { success: true, count: seeded_count }
  end

  def hydrate_movie(tmdb_id)
    Rails.logger.info "Hydrating movie with TMDB ID: #{tmdb_id}"
    
    return { success: false, error: 'Movie already exists' } if Movie.exists?(tmdb_id: tmdb_id)
    
    begin
      movie_details = @client.fetch_movie_details(tmdb_id)
      movie_credits = @client.fetch_credits(tmdb_id)
      
      # Find or create production country
      country_code = movie_details['production_countries']&.first&.dig('iso_3166_1') || 'US'
      country = ProductionCountry.find_by(iso_3166_1: country_code)
      country ||= ProductionCountry.create!(name: 'Unknown', iso_3166_1: country_code)
      
      # Find or create original language
      language_code = movie_details['original_language'] || 'en'
      language = OriginalLanguage.find_by(iso_639_1: language_code)
      language ||= OriginalLanguage.create!(name: 'Unknown', iso_639_1: language_code)
      
      # Create movie
      movie = Movie.create!(
        tmdb_id: movie_details['id'],
        title: movie_details['title'],
        overview: movie_details['overview'],
        release_date: movie_details['release_date'] ? Date.parse(movie_details['release_date']) : nil,
        vote_average: movie_details['vote_average'] || 0,
        vote_count: movie_details['vote_count'] || 0,
        poster_path: movie_details['poster_path'],
        backdrop_path: movie_details['backdrop_path'],
        runtime: movie_details['runtime'],
        production_country: country,
        original_language: language
      )
      
      # Add genres
      if movie_details['genres']
        movie_details['genres'].each do |genre_data|
          genre = Genre.find_by(tmdb_id: genre_data['id'])
          if genre
            movie.genres << genre unless movie.genres.include?(genre)
          end
        end
      end
      
      # Add people (directors, actors, writers)
      if movie_credits['crew']
        movie_credits['crew'].each do |person_data|
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
      
      Rails.logger.info "Successfully hydrated movie: #{movie.title}"
      { success: true, title: movie.title, movie: movie }
      
    rescue TmdbClientError => e
      Rails.logger.error "Failed to hydrate movie: #{e.message}"
      { success: false, error: e.message }
    rescue => e
      Rails.logger.error "Unexpected error hydrating movie: #{e.message}"
      { success: false, error: e.message }
    end
  end

  def seed_all
    Rails.logger.info "Starting complete TMDB seeding..."
    
    results = {}
    results[:genres] = seed_genres
    results[:countries] = seed_production_countries
    results[:languages] = seed_original_languages
    results[:movies] = seed_demo_movies
    
    Rails.logger.info "TMDB seeding completed: #{results}"
    results
  end
end
