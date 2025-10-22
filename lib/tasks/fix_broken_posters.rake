# frozen_string_literal: true

namespace :movies do
  desc "Fix known broken TMDB poster paths"
  task fix_broken_posters: :environment do
    puts "🔧 Fixing broken TMDB poster paths..."
    puts ""
    
    # Updated poster paths for movies known to have broken images
    # These are verified working TMDB poster IDs
    fixes = {
      'Up' => { poster: '/mFvoEwSfLqbcWwFsDjQebn9bzFe.jpg', backdrop: '/oVuCMzqvhZG7fBw1a3SfDkGdLGK.jpg' },
      'Saving Private Ryan' => { poster: '/hjQp148VjWF2aXAImSnIP5xWLRV.jpg', backdrop: '/vSNxAJTlD0r02V9sPYpOjqDZXUK.jpg' },
      'Akira' => { poster: '/nKuXgY2utmNkWcHrdq3GHY8mnXR.jpg', backdrop: '/4HWAQu28e2yaWrtupFPGFkdNU7V.jpg' },
      
      # Add more fixes here as needed
      # 'Movie Title' => { poster: '/path.jpg', backdrop: '/path.jpg' },
    }
    
    fixed_count = 0
    not_found_count = 0
    
    fixes.each do |title, paths|
      movie = Movie.find_by(title: title)
      if movie
        old_poster = movie.poster_path
        movie.update!(
          poster_path: paths[:poster],
          backdrop_path: paths[:backdrop]
        )
        puts "✓ Fixed: #{title}"
        puts "  Old: #{old_poster}"
        puts "  New: #{paths[:poster]}"
        puts ""
        fixed_count += 1
      else
        puts "⚠ Not found: #{title}"
        not_found_count += 1
      end
    end
    
    puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    puts "✅ Fixed #{fixed_count} broken poster paths"
    puts "⚠️  #{not_found_count} movies not found" if not_found_count > 0
    puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  end
end

