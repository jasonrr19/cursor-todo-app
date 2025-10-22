# frozen_string_literal: true

namespace :db do
  namespace :movies do
    desc "Remove inappropriate films from the database"
    task remove_inappropriate: :environment do
      puts "🔍 Searching for inappropriate films..."
      
      # List of inappropriate film titles/keywords to remove
      inappropriate_keywords = [
        'torture hell',
        'lesbians in uniforms',
        'beautiful teacher in torture',
        'killer pussy',
        'killer pussies'
      ]
      
      removed_count = 0
      
      inappropriate_keywords.each do |keyword|
        movies = Movie.where("LOWER(title) LIKE ?", "%#{keyword.downcase}%")
        movies.each do |movie|
          puts "  ❌ Removing: #{movie.title} (ID: #{movie.id})"
          movie.destroy
          removed_count += 1
        end
      end
      
      if removed_count > 0
        puts "\n✅ Removed #{removed_count} inappropriate film(s)"
      else
        puts "\n✓ No inappropriate films found"
      end
    end
  end
end

