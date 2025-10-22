# frozen_string_literal: true

namespace :movies do
  desc "Fetch correct TMDB poster paths for broken movies"
  task fetch_tmdb_posters: :environment do
    require 'net/http'
    require 'uri'
    require 'json'
    
    api_key = ENV['TMDB_API_KEY']
    unless api_key
      puts "❌ ERROR: TMDB_API_KEY environment variable not set"
      exit 1
    end
    
    puts "🔍 Fetching correct TMDB poster paths for broken movies..."
    puts ""
    
    # List of broken movies - we'll fetch their TMDB data
    broken_movies = [
      { title: 'The Fabelmans', tmdb_id: 5110 },
      { title: 'The Northman', tmdb_id: 639933 },
      { title: 'Moonlight', tmdb_id: 376867 },
      { title: 'Eternal Sunshine of the Spotless Mind', tmdb_id: 38 },
      { title: 'Pan\'s Labyrinth', tmdb_id: 1121 },
      { title: 'Casino Royale', tmdb_id: 36557 },
      { title: 'The Bourne Ultimatum', tmdb_id: 2503 },
      { title: '28 Days Later', tmdb_id: 170 },
      { title: 'Shaun of the Dead', tmdb_id: 747 },
      { title: 'Hot Fuzz', tmdb_id: 4638 },
      { title: 'Oldboy', tmdb_id: 670 },
      { title: 'Children of Men', tmdb_id: 9693 },
      { title: 'V for Vendetta', tmdb_id: 752 },
      { title: 'Howl\'s Moving Castle', tmdb_id: 4935 },
      { title: 'Zombieland', tmdb_id: 19908 },
      { title: 'District 9', tmdb_id: 17654 },
      { title: 'The Big Lebowski', tmdb_id: 115 },
      { title: 'Saving Private Ryan', tmdb_id: 857 },
      { title: 'Reservoir Dogs', tmdb_id: 500 },
      { title: 'L.A. Confidential', tmdb_id: 9521 },
      { title: 'The Usual Suspects', tmdb_id: 629 },
      { title: 'Toy Story 2', tmdb_id: 863 },
      { title: 'The Iron Giant', tmdb_id: 10386 },
      { title: 'Heat', tmdb_id: 949 },
      { title: 'The Nightmare Before Christmas', tmdb_id: 9479 },
      { title: 'Scream', tmdb_id: 4232 },
      { title: 'E.T. the Extra-Terrestrial', tmdb_id: 601 },
      { title: 'Return of the Jedi', tmdb_id: 1892 },
      { title: 'Full Metal Jacket', tmdb_id: 10387 },
      { title: 'The Breakfast Club', tmdb_id: 2108 },
      { title: 'Ghostbusters', tmdb_id: 620 },
      { title: 'The Princess Bride', tmdb_id: 2493 },
      { title: 'Grave of the Fireflies', tmdb_id: 12477 },
      { title: 'The Goonies', tmdb_id: 9340 },
      { title: 'Akira', tmdb_id: 149 },
      { title: 'The Evil Dead', tmdb_id: 6218 },
      { title: 'Raging Bull', tmdb_id: 30 },
      { title: 'Amadeus', tmdb_id: 279 },
      { title: 'The Untouchables', tmdb_id: 8124 },
      { title: 'Platoon', tmdb_id: 792 },
      { title: 'Indiana Jones and the Last Crusade', tmdb_id: 89 },
      { title: 'Lethal Weapon', tmdb_id: 941 },
      { title: 'Predator', tmdb_id: 106 },
      { title: 'One Flew Over the Cuckoo\'s Nest', tmdb_id: 510 },
      { title: 'Chinatown', tmdb_id: 4944 },
      { title: 'The Deer Hunter', tmdb_id: 12067 },
      { title: 'Annie Hall', tmdb_id: 1562 },
      { title: 'Monty Python and the Holy Grail', tmdb_id: 762 },
      { title: 'Close Encounters of the Third Kind', tmdb_id: 840 },
      { title: 'Network', tmdb_id: 12133 }
    ]
    
    fixed_count = 0
    failed_count = 0
    
    broken_movies.each do |movie_data|
      tmdb_id = movie_data[:tmdb_id]
      title = movie_data[:title]
      
      begin
        # Fetch movie details from TMDB API
        uri = URI.parse("https://api.themoviedb.org/3/movie/#{tmdb_id}?api_key=#{api_key}")
        response = Net::HTTP.get_response(uri)
        
        if response.code == '200'
          data = JSON.parse(response.body)
          poster_path = data['poster_path']
          backdrop_path = data['backdrop_path']
          
          # Find movie in database and update
          movie = Movie.find_by(title: title)
          if movie && poster_path
            old_poster = movie.poster_path
            movie.update!(
              poster_path: poster_path,
              backdrop_path: backdrop_path
            )
            puts "✓ #{title}"
            puts "  Old: #{old_poster}"
            puts "  New: #{poster_path}"
            puts ""
            fixed_count += 1
          else
            puts "⚠️  #{title} - No poster found in TMDB"
            failed_count += 1
          end
        else
          puts "❌ #{title} - API error: #{response.code}"
          failed_count += 1
        end
        
        # Rate limiting - TMDB allows 40 requests per 10 seconds
        sleep 0.3
        
      rescue => e
        puts "❌ #{title} - Error: #{e.message}"
        failed_count += 1
      end
    end
    
    puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    puts "✅ Fixed #{fixed_count} movies with TMDB API data"
    puts "❌ Failed: #{failed_count}" if failed_count > 0
    puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  end
end

