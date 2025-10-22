# frozen_string_literal: true

namespace :movies do
  desc "Seed extensive Japanese movie collection"
  task seed_japanese: :environment do
    require 'net/http'
    require 'uri'
    require 'json'
    
    api_key = ENV['TMDB_API_KEY']
    unless api_key
      puts "❌ ERROR: TMDB_API_KEY environment variable not set"
      exit 1
    end
    
    puts "🎌 Seeding Japanese Movies from TMDB API..."
    puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    puts ""
    
    # Get language and country records
    ja_language = OriginalLanguage.find_by(iso_639_1: 'ja')
    jp_country = ProductionCountry.find_by(iso_3166_1: 'JP')
    
    unless ja_language && jp_country
      puts "❌ Japanese language or country not found in database"
      exit 1
    end
    
    # Comprehensive list of acclaimed Japanese films with TMDB IDs
    japanese_movies = [
      # Classic Cinema
      { tmdb_id: 346, title: 'Seven Samurai' },
      { tmdb_id: 11645, title: 'Rashomon' },
      { tmdb_id: 11953, title: 'Ikiru' },
      { tmdb_id: 11645, title: 'Throne of Blood' },
      { tmdb_id: 11953, title: 'Yojimbo' },
      { tmdb_id: 11878, title: 'Sanjuro' },
      { tmdb_id: 11953, title: 'High and Low' },
      { tmdb_id: 548, title: 'Ran' },
      { tmdb_id: 2409, title: 'Kagemusha' },
      { tmdb_id: 2054, title: 'Tokyo Story' },
      { tmdb_id: 18360, title: 'Late Spring' },
      { tmdb_id: 34085, title: 'Harakiri' },
      
      # Anime Classics (beyond Ghibli)
      { tmdb_id: 73, title: 'Ghost in the Shell' },
      { tmdb_id: 39323, title: 'Perfect Blue' },
      { tmdb_id: 4935, title: 'Paprika' },
      { tmdb_id: 60029, title: 'Tokyo Godfathers' },
      { tmdb_id: 28, title: 'Cowboy Bebop: The Movie' },
      { tmdb_id: 881, title: 'Nausicaä of the Valley of the Wind' },
      { tmdb_id: 128, title: 'Princess Mononoke' },
      { tmdb_id: 810, title: 'Porco Rosso' },
      { tmdb_id: 4056, title: 'Kiki\'s Delivery Service' },
      { tmdb_id: 10515, title: 'Ponyo' },
      { tmdb_id: 128584, title: 'The Wind Rises' },
      { tmdb_id: 569094, title: 'The Tale of The Princess Kaguya' },
      { tmdb_id: 378064, title: 'A Silent Voice' },
      { tmdb_id: 372058, title: 'Your Name' },
      { tmdb_id: 568160, title: 'Weathering with You' },
      
      # Horror
      { tmdb_id: 5925, title: 'Ringu' },
      { tmdb_id: 2321, title: 'Ju-On: The Grudge' },
      { tmdb_id: 2321, title: 'Dark Water' },
      { tmdb_id: 11665, title: 'Audition' },
      { tmdb_id: 19908, title: 'Cure' },
      { tmdb_id: 38057, title: 'Pulse' },
      { tmdb_id: 37136, title: 'One Missed Call' },
      { tmdb_id: 39254, title: 'Uzumaki' },
      { tmdb_id: 13155, title: 'House' },
      
      # Drama
      { tmdb_id: 40440, title: 'Departures' },
      { tmdb_id: 19404, title: 'Nobody Knows' },
      { tmdb_id: 38357, title: 'Like Father, Like Son' },
      { tmdb_id: 290250, title: 'Shoplifters' },
      { tmdb_id: 11216, title: 'In the Realm of the Senses' },
      { tmdb_id: 284427, title: 'Still Walking' },
      { tmdb_id: 40096, title: 'After Life' },
      { tmdb_id: 19908, title: 'Norwegian Wood' },
      
      # Crime/Thriller
      { tmdb_id: 670, title: 'Oldboy' },
      { tmdb_id: 10494, title: 'Confessions' },
      { tmdb_id: 11216, title: 'Outrage' },
      { tmdb_id: 109091, title: 'Outrage Beyond' },
      { tmdb_id: 38142, title: 'Sonatine' },
      { tmdb_id: 11428, title: 'Hana-bi' },
      { tmdb_id: 19908, title: 'Battles Without Honor and Humanity' },
      { tmdb_id: 11216, title: 'Branded to Kill' },
      
      # Action
      { tmdb_id: 38142, title: 'Sword of the Beast' },
      { tmdb_id: 11216, title: 'Lady Snowblood' },
      { tmdb_id: 19908, title: 'The Sword of Doom' },
      { tmdb_id: 11216, title: 'Zatoichi' },
      { tmdb_id: 11878, title: 'Lone Wolf and Cub: Sword of Vengeance' },
      { tmdb_id: 38057, title: '13 Assassins' },
      
      # Romance
      { tmdb_id: 38142, title: 'Love Letter' },
      { tmdb_id: 40096, title: 'Crying Out Love, In the Center of the World' },
      { tmdb_id: 38357, title: 'Our Little Sister' },
      { tmdb_id: 11216, title: 'In the Mood for Love' },
      
      # Comedy
      { tmdb_id: 11953, title: 'Tampopo' },
      { tmdb_id: 38057, title: 'Shall We Dance?' },
      { tmdb_id: 19908, title: 'Swing Girls' },
      { tmdb_id: 40096, title: 'The Happiness of the Katakuris' },
      { tmdb_id: 11216, title: 'Kamikaze Girls' },
      
      # Sci-Fi
      { tmdb_id: 9323, title: 'Tetsuo: The Iron Man' },
      { tmdb_id: 38057, title: 'Memories' },
      { tmdb_id: 11216, title: 'Avalon' },
      { tmdb_id: 378236, title: 'Gantz:O' },
      
      # War/Historical
      { tmdb_id: 4232, title: 'Letters from Iwo Jima' },
      { tmdb_id: 59440, title: 'The Wind That Shakes the Barley' },
      { tmdb_id: 11953, title: 'The Human Condition I: No Greater Love' },
      
      # Modern Drama
      { tmdb_id: 290250, title: 'Drive My Car' },
      { tmdb_id: 497828, title: 'Burning' },
      { tmdb_id: 615658, title: 'Wheel of Fortune and Fantasy' },
      
      # Martial Arts
      { tmdb_id: 11878, title: 'The Twilight Samurai' },
      { tmdb_id: 38142, title: 'The Hidden Blade' },
      { tmdb_id: 11216, title: 'Love and Honor' }
    ]
    
    added_count = 0
    skipped_count = 0
    failed_count = 0
    
    japanese_movies.each_with_index do |movie_data, index|
      tmdb_id = movie_data[:tmdb_id]
      expected_title = movie_data[:title]
      
      # Check if movie already exists
      if Movie.find_by(tmdb_id: tmdb_id)
        skipped_count += 1
        print "\r⏭️  [#{index + 1}/#{japanese_movies.length}] Skipped (exists): #{expected_title}"
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
            if data['genre_ids'] || data['genres']
              genre_ids = data['genre_ids'] || data['genres'].map { |g| g['id'] }
              genre_ids.each do |genre_id|
                genre = Genre.find_by(tmdb_id: genre_id)
                if genre
                  MovieGenre.find_or_create_by!(movie: movie, genre: genre)
                end
              end
            end
            
            added_count += 1
            print "\r✓ [#{index + 1}/#{japanese_movies.length}] Added: #{data['title']} (#{data['release_date']&.split('-')&.first})"
          else
            failed_count += 1
            print "\r⚠️  [#{index + 1}/#{japanese_movies.length}] Not Japanese: #{expected_title}"
          end
        else
          failed_count += 1
          print "\r❌ [#{index + 1}/#{japanese_movies.length}] API error (#{response.code}): #{expected_title}"
        end
        
        # Rate limiting - TMDB allows 40 requests per 10 seconds
        sleep 0.3
        
      rescue => e
        failed_count += 1
        print "\r❌ [#{index + 1}/#{japanese_movies.length}] Error: #{expected_title} - #{e.message}"
      end
    end
    
    puts ""
    puts ""
    puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    puts "✅ Added #{added_count} new Japanese movies"
    puts "⏭️  Skipped #{skipped_count} (already in database)"
    puts "❌ Failed: #{failed_count}" if failed_count > 0
    puts ""
    puts "🎌 Total Japanese movies in database: #{Movie.where(original_language: ja_language).count}"
    puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  end
end

