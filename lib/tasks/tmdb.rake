# frozen_string_literal: true

namespace :tmdb do
  desc 'Seed genres from TMDB API'
  task seed_genres: :environment do
    seeder = TmdbSeederService.new
    result = seeder.seed_genres
    
    if result[:success]
      puts "✅ Successfully seeded #{result[:count]} genres"
    else
      puts "❌ Failed to seed genres: #{result[:error]}"
      exit 1
    end
  end

  desc 'Seed production countries'
  task seed_countries: :environment do
    seeder = TmdbSeederService.new
    result = seeder.seed_production_countries
    
    if result[:success]
      puts "✅ Successfully seeded #{result[:count]} production countries"
    else
      puts "❌ Failed to seed countries: #{result[:error]}"
      exit 1
    end
  end

  desc 'Seed original languages'
  task seed_languages: :environment do
    seeder = TmdbSeederService.new
    result = seeder.seed_original_languages
    
    if result[:success]
      puts "✅ Successfully seeded #{result[:count]} original languages"
    else
      puts "❌ Failed to seed languages: #{result[:error]}"
      exit 1
    end
  end

  desc 'Seed demo movies (J-Horror 2000s)'
  task seed_demo_movies: :environment do
    seeder = TmdbSeederService.new
    result = seeder.seed_demo_movies
    
    if result[:success]
      puts "✅ Successfully seeded #{result[:count]} demo movies"
    else
      puts "❌ Failed to seed demo movies: #{result[:error]}"
      exit 1
    end
  end

  desc 'Seed all TMDB data'
  task seed_all: :environment do
    puts "🌱 Starting complete TMDB seeding..."
    
    seeder = TmdbSeederService.new
    results = seeder.seed_all
    
    puts "\n📊 Seeding Results:"
    results.each do |type, result|
      if result[:success]
        puts "  ✅ #{type.to_s.capitalize}: #{result[:count]} items"
      else
        puts "  ❌ #{type.to_s.capitalize}: #{result[:error]}"
      end
    end
    
    puts "\n🎉 TMDB seeding completed!"
  end

  desc 'Hydrate a specific movie by TMDB ID'
  task :hydrate_movie, [:tmdb_id] => :environment do |_task, args|
    tmdb_id = args[:tmdb_id]
    
    if tmdb_id.blank?
      puts "❌ Please provide a TMDB ID: rake tmdb:hydrate_movie[12345]"
      exit 1
    end
    
    puts "🎬 Hydrating movie with TMDB ID: #{tmdb_id}"
    
    seeder = TmdbSeederService.new
    result = seeder.hydrate_movie(tmdb_id)
    
    if result[:success]
      puts "✅ Successfully hydrated movie: #{result[:title]}"
    else
      puts "❌ Failed to hydrate movie: #{result[:error]}"
      exit 1
    end
  end

  desc 'Queue credits fetch for all movies without credits'
  task queue_missing_credits: :environment do
    puts "Queueing credits fetch for movies without credits..."
    service = MovieHydrationService.new
    count = service.queue_missing_credits
    puts "✅ Queued credits fetch for #{count} movies"
  end

  desc 'Queue credits fetch for movies with incomplete credits'
  task queue_incomplete_credits: :environment do
    puts "Queueing credits fetch for movies with incomplete credits..."
    service = MovieHydrationService.new
    count = service.queue_incomplete_credits
    puts "✅ Queued credits fetch for #{count} movies with incomplete credits"
  end

  desc 'Show hydration status'
  task status: :environment do
    puts "Movie Hydration Status:"
    puts "=" * 50
    service = MovieHydrationService.new
    status = service.overall_hydration_status
    
    puts "Total Movies: #{status[:total_movies]}"
    puts "Movies with Credits: #{status[:movies_with_credits]}"
    puts "Movies without Credits: #{status[:movies_without_credits]}"
    puts "Hydration Percentage: #{status[:hydration_percentage]}%"
    puts "Total People: #{status[:total_people]}"
    puts "Total Credits: #{status[:total_credits]}"
  end

  desc 'Clean up orphaned relationships'
  task cleanup: :environment do
    puts "Cleaning up orphaned relationships..."
    service = MovieHydrationService.new
    count = service.cleanup_orphaned_relationships
    puts "✅ Cleaned up #{count} orphaned relationships"
  end
end
