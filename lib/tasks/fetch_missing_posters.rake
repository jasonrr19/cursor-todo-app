namespace :db do
  namespace :movies do
    desc "Fetch missing poster paths from TMDB API"
    task fetch_missing_posters: :environment do
      require 'httparty'
      
      puts "🎬 Fetching missing poster paths from TMDB..."
      
      client = TmdbClient.new
      movies_without_posters = Movie.where(poster_path: nil)
      
      puts "Found #{movies_without_posters.count} movies without posters"
      
      updated_count = 0
      failed_count = 0
      
      movies_without_posters.each_with_index do |movie, index|
        begin
          puts "  [#{index + 1}/#{movies_without_posters.count}] Searching for: #{movie.title}..."
          
          # Search for the movie by title and year
          year = movie.release_date&.year
          results = client.search_movies(movie.title, year: year)
          
          if results && results['results'] && results['results'].any?
            # Take the first result (most relevant)
            tmdb_movie = results['results'].first
            
            if tmdb_movie['poster_path']
              movie.update!(
                poster_path: tmdb_movie['poster_path'],
                backdrop_path: tmdb_movie['backdrop_path'],
                tmdb_id: tmdb_movie['id'],
                overview: tmdb_movie['overview'] || movie.overview
              )
              updated_count += 1
              puts "    ✓ Updated: #{movie.title} (#{movie.poster_path})"
            else
              puts "    ⚠ No poster found for: #{movie.title}"
              failed_count += 1
            end
          else
            puts "    ✗ No results found for: #{movie.title}"
            failed_count += 1
          end
          
          # Rate limiting: TMDB allows 40 requests per 10 seconds
          sleep(0.3) # ~3 requests per second
        rescue => e
          puts "    ✗ Error for #{movie.title}: #{e.message}"
          failed_count += 1
        end
      end
      
      puts ""
      puts "=" * 70
      puts "✅ COMPLETE!"
      puts "=" * 70
      puts "  Updated: #{updated_count} movies"
      puts "  Failed:  #{failed_count} movies"
      puts "  Total movies with posters: #{Movie.where.not(poster_path: nil).count}"
      puts "=" * 70
    end
  end
end

