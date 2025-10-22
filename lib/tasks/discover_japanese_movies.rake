# frozen_string_literal: true

namespace :movies do
  desc "Discover and add popular Japanese movies from TMDB"
  task discover_japanese: :environment do
    require 'net/http'
    require 'uri'
    require 'json'
    
    api_key = ENV['TMDB_API_KEY']
    unless api_key
      puts "❌ ERROR: TMDB_API_KEY environment variable not set"
      exit 1
    end
    
    puts "🎌 Discovering Popular Japanese Movies from TMDB..."
    puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    puts ""
    
    # Get language and country records
    ja_language = OriginalLanguage.find_by(iso_639_1: 'ja')
    jp_country = ProductionCountry.find_by(iso_3166_1: 'JP')
    
    unless ja_language && jp_country
      puts "❌ Japanese language or country not found in database"
      exit 1
    end
    
    added_count = 0
    skipped_count = 0
    total_found = 0
    
    # Use TMDB's discover endpoint to find Japanese movies
    # We'll fetch multiple pages to get a good variety
    (1..10).each do |page|
      puts "\n📄 Fetching page #{page}..."
      
      begin
        # Discover Japanese movies, sorted by popularity
        uri = URI.parse("https://api.themoviedb.org/3/discover/movie?api_key=#{api_key}&with_original_language=ja&sort_by=popularity.desc&page=#{page}&vote_count.gte=10")
        response = Net::HTTP.get_response(uri)
        
        if response.code == '200'
          data = JSON.parse(response.body)
          movies = data['results'] || []
          total_found += movies.length
          
          puts "Found #{movies.length} movies on this page"
          
          movies.each do |movie_data|
            tmdb_id = movie_data['id']
            
            # Check if movie already exists
            if Movie.find_by(tmdb_id: tmdb_id)
              skipped_count += 1
              next
            end
            
            # Fetch full movie details to get runtime and more accurate data
            begin
              detail_uri = URI.parse("https://api.themoviedb.org/3/movie/#{tmdb_id}?api_key=#{api_key}")
              detail_response = Net::HTTP.get_response(detail_uri)
              
              if detail_response.code == '200'
                details = JSON.parse(detail_response.body)
                
                # Create movie
                movie = Movie.create!(
                  tmdb_id: tmdb_id,
                  title: details['title'],
                  overview: details['overview'],
                  release_date: details['release_date'],
                  runtime: details['runtime'],
                  vote_average: details['vote_average'] || 0,
                  vote_count: details['vote_count'] || 0,
                  popularity: details['popularity'] || 0,
                  poster_path: details['poster_path'],
                  backdrop_path: details['backdrop_path'],
                  original_language: ja_language,
                  production_country: jp_country
                )
                
                # Add genres
                if details['genres']
                  details['genres'].each do |genre_data|
                    genre = Genre.find_by(tmdb_id: genre_data['id'])
                    if genre
                      MovieGenre.find_or_create_by!(movie: movie, genre: genre)
                    end
                  end
                end
                
                added_count += 1
                year = details['release_date']&.split('-')&.first || 'N/A'
                genres = details['genres']&.map { |g| g['name'] }&.join(', ') || 'N/A'
                puts "  ✓ Added: #{details['title']} (#{year}) - #{genres}"
                
                # Rate limiting
                sleep 0.3
              end
            rescue => e
              puts "  ⚠️  Error fetching details for #{movie_data['title']}: #{e.message}"
            end
          end
        else
          puts "❌ API error: #{response.code}"
          break
        end
        
        # Rate limiting between pages
        sleep 0.5
        
      rescue => e
        puts "❌ Error on page #{page}: #{e.message}"
        break
      end
    end
    
    puts ""
    puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    puts "✅ Added #{added_count} new Japanese movies"
    puts "⏭️  Skipped #{skipped_count} (already in database)"
    puts "📊 Total found across all pages: #{total_found}"
    puts ""
    puts "🎌 Total Japanese movies in database: #{Movie.where(original_language: ja_language).count}"
    puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  end
end

