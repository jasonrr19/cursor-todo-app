# frozen_string_literal: true

namespace :movies do
  desc "Add quality Japanese movies (family-friendly and critically acclaimed)"
  task add_quality_japanese: :environment do
    require 'net/http'
    require 'uri'
    require 'json'
    
    api_key = ENV['TMDB_API_KEY']
    unless api_key
      puts "❌ ERROR: TMDB_API_KEY environment variable not set"
      exit 1
    end
    
    puts "🎌 Adding Quality Japanese Movies..."
    puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    puts ""
    
    # Get language and country records
    ja_language = OriginalLanguage.find_by(iso_639_1: 'ja')
    jp_country = ProductionCountry.find_by(iso_3166_1: 'JP')
    
    unless ja_language && jp_country
      puts "❌ Japanese language or country not found in database"
      exit 1
    end
    
    # Curated list of high-quality, critically acclaimed Japanese films
    quality_movies = [
      # Kurosawa Classics
      { tmdb_id: 346, title: 'Seven Samurai' },
      { tmdb_id: 11645, title: 'Rashomon' },
      { tmdb_id: 11953, title: 'Yojimbo' },
      { tmdb_id: 11878, title: 'Sanjuro' },
      { tmdb_id: 2409, title: 'Kagemusha' },
      { tmdb_id: 11362, title: 'Throne of Blood' },
      { tmdb_id: 11953, title: 'The Hidden Fortress' },
      
      # Other Classic Directors
      { tmdb_id: 18360, title: 'Late Spring' },
      { tmdb_id: 2054, title: 'Tokyo Story' },
      { tmdb_id: 34085, title: 'Harakiri' },
      { tmdb_id: 11216, title: 'Tokyo Drifter' },
      { tmdb_id: 38142, title: 'Sword of the Beast' },
      
      # Modern Acclaimed Drama
      { tmdb_id: 40440, title: 'Departures' },
      { tmdb_id: 19404, title: 'Nobody Knows' },
      { tmdb_id: 38357, title: 'Like Father, Like Son' },
      { tmdb_id: 290250, title: 'Shoplifters' },
      { tmdb_id: 284427, title: 'Still Walking' },
      { tmdb_id: 40096, title: 'After Life' },
      { tmdb_id: 497828, title: 'Burning' },
      { tmdb_id: 615658, title: 'Wheel of Fortune and Fantasy' },
      
      # Samurai/Period Films
      { tmdb_id: 11216, title: 'Lady Snowblood' },
      { tmdb_id: 11878, title: 'The Twilight Samurai' },
      { tmdb_id: 38142, title: 'The Hidden Blade' },
      { tmdb_id: 11216, title: 'Love and Honor' },
      { tmdb_id: 19908, title: 'The Sword of Doom' },
      { tmdb_id: 11216, title: 'Zatoichi' },
      
      # Crime/Yakuza
      { tmdb_id: 11216, title: 'Outrage' },
      { tmdb_id: 109091, title: 'Outrage Beyond' },
      { tmdb_id: 38142, title: 'Sonatine' },
      { tmdb_id: 11428, title: 'Hana-bi' },
      { tmdb_id: 11216, title: 'Branded to Kill' },
      
      # Romance
      { tmdb_id: 38142, title: 'Love Letter' },
      { tmdb_id: 38357, title: 'Our Little Sister' },
      { tmdb_id: 40096, title: 'Crying Out Love, In the Center of the World' },
      
      # Animation (Non-Ghibli)
      { tmdb_id: 73, title: 'Ghost in the Shell' },
      { tmdb_id: 39323, title: 'Perfect Blue' },
      { tmdb_id: 4935, title: 'Paprika' },
      { tmdb_id: 60029, title: 'Tokyo Godfathers' },
      { tmdb_id: 28, title: 'Millennium Actress' },
      
      # Horror (Non-exploitative)
      { tmdb_id: 5925, title: 'Ringu' },
      { tmdb_id: 2321, title: 'Dark Water' },
      { tmdb_id: 11665, title: 'Audition' },
      { tmdb_id: 38057, title: 'Pulse' },
      { tmdb_id: 37136, title: 'One Missed Call' },
      
      # Comedy
      { tmdb_id: 11953, title: 'Tampopo' },
      { tmdb_id: 38057, title: 'Shall We Dance?' },
      { tmdb_id: 19908, title: 'Swing Girls' },
      { tmdb_id: 11216, title: 'Kamikaze Girls' }
    ]
    
    added_count = 0
    skipped_count = 0
    failed_count = 0
    
    quality_movies.each_with_index do |movie_data, index|
      tmdb_id = movie_data[:tmdb_id]
      expected_title = movie_data[:title]
      
      # Check if movie already exists
      if Movie.find_by(tmdb_id: tmdb_id)
        skipped_count += 1
        next
      end
      
      begin
        # Fetch movie details from TMDB API
        uri = URI.parse("https://api.themoviedb.org/3/movie/#{tmdb_id}?api_key=#{api_key}")
        response = Net::HTTP.get_response(uri)
        
        if response.code == '200'
          data = JSON.parse(response.body)
          
          # Only add if it's actually a Japanese movie
          if data['original_language'] == 'ja'
            # Create movie
            movie = Movie.create!(
              tmdb_id: tmdb_id,
              title: data['title'],
              overview: data['overview'],
              release_date: data['release_date'],
              runtime: data['runtime'],
              vote_average: data['vote_average'] || 0,
              vote_count: data['vote_count'] || 0,
              popularity: data['popularity'] || 0,
              poster_path: data['poster_path'],
              backdrop_path: data['backdrop_path'],
              original_language: ja_language,
              production_country: jp_country
            )
            
            # Add genres
            if data['genres']
              data['genres'].each do |genre_data|
                genre = Genre.find_by(tmdb_id: genre_data['id'])
                if genre
                  MovieGenre.find_or_create_by!(movie: movie, genre: genre)
                end
              end
            end
            
            added_count += 1
            year = data['release_date']&.split('-')&.first || 'N/A'
            puts "✓ Added: #{data['title']} (#{year})"
          else
            failed_count += 1
          end
        else
          failed_count += 1
        end
        
        # Rate limiting
        sleep 0.3
        
      rescue => e
        failed_count += 1
        puts "❌ Error: #{expected_title} - #{e.message}"
      end
    end
    
    puts ""
    puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    puts "✅ Added #{added_count} quality Japanese movies"
    puts "⏭️  Skipped #{skipped_count} (already in database)"
    puts "❌ Failed: #{failed_count}" if failed_count > 0
    puts ""
    puts "🎌 Total Japanese movies in database: #{Movie.where(original_language: ja_language).count}"
    puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  end
end

