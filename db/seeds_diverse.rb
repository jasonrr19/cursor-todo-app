# frozen_string_literal: true

# Cinema List Derby - Diverse Seed Data
# This seed creates a varied collection of movies across genres, countries, and eras (1970s-2020s)

puts "🎬 Cinema List Derby - Seeding Diverse Movie Collection..."
puts ""

# Clear existing data if requested
if Rails.env.development? && ENV['CLEAR_DATA'] == 'true'
  puts "⚠️  Clearing existing data..."
  [RecommendationEvent, SearchQuery, Review, ListMovie, List, MoviePerson, MovieGenre, WatchedMovie,
   Movie, UserPreference, User, Person, Genre, OriginalLanguage, ProductionCountry].each do |model|
    model.destroy_all
  end
  puts "✓ Data cleared"
  puts ""
end

# ===== STEP 1: Core Data =====
puts "📊 Creating core data..."

# Production Countries - Expanded list
countries_data = [
  { name: 'United States of America', iso_3166_1: 'US' },
  { name: 'United Kingdom', iso_3166_1: 'GB' },
  { name: 'France', iso_3166_1: 'FR' },
  { name: 'Germany', iso_3166_1: 'DE' },
  { name: 'Italy', iso_3166_1: 'IT' },
  { name: 'Spain', iso_3166_1: 'ES' },
  { name: 'Japan', iso_3166_1: 'JP' },
  { name: 'South Korea', iso_3166_1: 'KR' },
  { name: 'China', iso_3166_1: 'CN' },
  { name: 'India', iso_3166_1: 'IN' },
  { name: 'Mexico', iso_3166_1: 'MX' },
  { name: 'Brazil', iso_3166_1: 'BR' },
  { name: 'Canada', iso_3166_1: 'CA' },
  { name: 'Australia', iso_3166_1: 'AU' },
  { name: 'Thailand', iso_3166_1: 'TH' }
]

countries_data.each do |country_data|
  country = ProductionCountry.find_or_initialize_by(iso_3166_1: country_data[:iso_3166_1])
  country.name = country_data[:name]
  country.save!
end
puts "✓ Created #{ProductionCountry.count} countries"

# Languages - Expanded list
languages_data = [
  { name: 'English', iso_639_1: 'en' },
  { name: 'French', iso_639_1: 'fr' },
  { name: 'Spanish', iso_639_1: 'es' },
  { name: 'German', iso_639_1: 'de' },
  { name: 'Italian', iso_639_1: 'it' },
  { name: 'Japanese', iso_639_1: 'ja' },
  { name: 'Korean', iso_639_1: 'ko' },
  { name: 'Mandarin', iso_639_1: 'zh' },
  { name: 'Hindi', iso_639_1: 'hi' },
  { name: 'Portuguese', iso_639_1: 'pt' },
  { name: 'Russian', iso_639_1: 'ru' },
  { name: 'Thai', iso_639_1: 'th' }
]

languages_data.each do |lang_data|
  lang = OriginalLanguage.find_or_initialize_by(iso_639_1: lang_data[:iso_639_1])
  lang.name = lang_data[:name]
  lang.save!
end
puts "✓ Created #{OriginalLanguage.count} languages"

# Genres - Complete list
genres_data = [
  { name: 'Action', tmdb_id: 28 },
  { name: 'Adventure', tmdb_id: 12 },
  { name: 'Animation', tmdb_id: 16 },
  { name: 'Comedy', tmdb_id: 35 },
  { name: 'Crime', tmdb_id: 80 },
  { name: 'Documentary', tmdb_id: 99 },
  { name: 'Drama', tmdb_id: 18 },
  { name: 'Family', tmdb_id: 10751 },
  { name: 'Fantasy', tmdb_id: 14 },
  { name: 'Horror', tmdb_id: 27 },
  { name: 'Mystery', tmdb_id: 9648 },
  { name: 'Romance', tmdb_id: 10749 },
  { name: 'Science Fiction', tmdb_id: 878 },
  { name: 'Thriller', tmdb_id: 53 },
  { name: 'War', tmdb_id: 10752 },
  { name: 'Western', tmdb_id: 37 }
]

genres_data.each do |genre_data|
  genre = Genre.find_or_initialize_by(tmdb_id: genre_data[:tmdb_id])
  genre.name = genre_data[:name]
  genre.save!
end
puts "✓ Created #{Genre.count} genres"

# ===== STEP 2: Demo Users =====
puts ""
puts "👤 Creating demo users..."

users = [
  { display_name: 'Movie Buff', theme_preference: 'dark' },
  { display_name: 'Casual Viewer', theme_preference: 'dark' },
  { display_name: 'Film Student', theme_preference: 'dark' }
]

users.each do |user_data|
  User.find_or_create_by!(display_name: user_data[:display_name]) do |u|
    u.theme_preference = user_data[:theme_preference]
  end
end
puts "✓ Created #{User.count} users"

# ===== STEP 3: Diverse Movie Collection =====
puts ""
puts "🎥 Adding diverse movie collection..."

# Helper to find or create references
us = ProductionCountry.find_by(iso_3166_1: 'US')
gb = ProductionCountry.find_by(iso_3166_1: 'GB')
fr = ProductionCountry.find_by(iso_3166_1: 'FR')
jp = ProductionCountry.find_by(iso_3166_1: 'JP')
kr = ProductionCountry.find_by(iso_3166_1: 'KR')

en = OriginalLanguage.find_by(iso_639_1: 'en')
fr_lang = OriginalLanguage.find_by(iso_639_1: 'fr')
ja = OriginalLanguage.find_by(iso_639_1: 'ja')
ko = OriginalLanguage.find_by(iso_639_1: 'ko')

action_genre = Genre.find_by(name: 'Action')
comedy_genre = Genre.find_by(name: 'Comedy')
drama_genre = Genre.find_by(name: 'Drama')
horror_genre = Genre.find_by(name: 'Horror')
scifi_genre = Genre.find_by(name: 'Science Fiction')
thriller_genre = Genre.find_by(name: 'Thriller')
animation_genre = Genre.find_by(name: 'Animation')
crime_genre = Genre.find_by(name: 'Crime')
mystery_genre = Genre.find_by(name: 'Mystery')
romance_genre = Genre.find_by(name: 'Romance')
adventure_genre = Genre.find_by(name: 'Adventure')
fantasy_genre = Genre.find_by(name: 'Fantasy')

# Diverse movie collection with proper genre associations
movies_data = [
  # 2020s - Modern blockbusters and indie
  { title: 'Dune', country: us, language: en, release_date: '2021-10-22', vote_count: 12500, vote_average: 7.8, popularity: 825.4, genres: [scifi_genre, adventure_genre] },
  { title: 'Everything Everywhere All at Once', country: us, language: en, release_date: '2022-03-25', vote_count: 8900, vote_average: 8.1, popularity: 567.2, genres: [scifi_genre, comedy_genre, action_genre] },
  { title: 'The Batman', country: us, language: en, release_date: '2022-03-04', vote_count: 9200, vote_average: 7.7, popularity: 712.8, genres: [crime_genre, mystery_genre, action_genre] },
  { title: 'Top Gun: Maverick', country: us, language: en, release_date: '2022-05-27', vote_count: 8100, vote_average: 8.3, popularity: 923.5, genres: [action_genre, drama_genre] },
  { title: 'Oppenheimer', country: us, language: en, release_date: '2023-07-21', vote_count: 7600, vote_average: 8.4, popularity: 892.1, genres: [drama_genre, thriller_genre] },
  
  # 2010s - Mix of genres
  { title: 'Inception', country: gb, language: en, release_date: '2010-07-16', vote_count: 38089, vote_average: 8.4, popularity: 956.2, genres: [scifi_genre, action_genre, thriller_genre] },
  { title: 'The Social Network', country: us, language: en, release_date: '2010-10-01', vote_count: 12800, vote_average: 7.7, popularity: 445.3, genres: [drama_genre] },
  { title: 'Mad Max: Fury Road', country: us, language: en, release_date: '2015-05-15', vote_count: 22300, vote_average: 7.6, popularity: 678.9, genres: [action_genre, adventure_genre, scifi_genre] },
  { title: 'Get Out', country: us, language: en, release_date: '2017-02-24', vote_count: 16800, vote_average: 7.6, popularity: 534.7, genres: [horror_genre, thriller_genre, mystery_genre] },
  { title: 'Parasite', country: kr, language: ko, release_date: '2019-05-30', vote_count: 17900, vote_average: 8.5, popularity: 892.4, genres: [thriller_genre, drama_genre, comedy_genre] },
  { title: 'Spider-Man: Into the Spider-Verse', country: us, language: en, release_date: '2018-12-14', vote_count: 19200, vote_average: 8.4, popularity: 745.2, genres: [animation_genre, action_genre, adventure_genre] },
  { title: 'Interstellar', country: us, language: en, release_date: '2014-11-07', vote_count: 35600, vote_average: 8.4, popularity: 1023.5, genres: [scifi_genre, drama_genre, adventure_genre] },
  { title: 'Whiplash', country: us, language: en, release_date: '2014-10-10', vote_count: 14700, vote_average: 8.3, popularity: 456.8, genres: [drama_genre] },
  
  # 2000s - Classics of the era
  { title: 'The Dark Knight', country: us, language: en, release_date: '2008-07-18', vote_count: 32900, vote_average: 9.0, popularity: 1245.6, genres: [action_genre, crime_genre, thriller_genre] },
  { title: 'WALL-E', country: us, language: en, release_date: '2008-06-27', vote_count: 18500, vote_average: 8.1, popularity: 623.4, genres: [animation_genre, scifi_genre, adventure_genre] },
  { title: 'Amélie', country: fr, language: fr_lang, release_date: '2001-04-25', vote_count: 13200, vote_average: 7.9, popularity: 512.7, genres: [comedy_genre, romance_genre] },
  { title: 'Spirited Away', country: jp, language: ja, release_date: '2001-07-20', vote_count: 16800, vote_average: 8.5, popularity: 892.3, genres: [animation_genre, adventure_genre, fantasy_genre] },
  { title: 'The Lord of the Rings: The Return of the King', country: us, language: en, release_date: '2003-12-17', vote_count: 28900, vote_average: 8.5, popularity: 1134.2, genres: [adventure_genre, fantasy_genre, action_genre] },
  { title: 'Finding Nemo', country: us, language: en, release_date: '2003-05-30', vote_count: 19700, vote_average: 7.8, popularity: 734.5, genres: [animation_genre, adventure_genre, comedy_genre] },
  { title: 'Eternal Sunshine of the Spotless Mind', country: us, language: en, release_date: '2004-03-19', vote_count: 11400, vote_average: 8.1, popularity: 478.9, genres: [drama_genre, romance_genre, scifi_genre] },
  
  # 1990s - Iconic 90s films
  { title: 'The Shawshank Redemption', country: us, language: en, release_date: '1994-09-23', vote_count: 27800, vote_average: 8.7, popularity: 1456.8, genres: [drama_genre, crime_genre] },
  { title: 'Pulp Fiction', country: us, language: en, release_date: '1994-10-14', vote_count: 29100, vote_average: 8.5, popularity: 1289.4, genres: [crime_genre, thriller_genre] },
  { title: 'The Matrix', country: us, language: en, release_date: '1999-03-31', vote_count: 26300, vote_average: 8.2, popularity: 1567.2, genres: [scifi_genre, action_genre] },
  { title: 'Goodfellas', country: us, language: en, release_date: '1990-09-19', vote_count: 14600, vote_average: 8.5, popularity: 923.7, genres: [crime_genre, drama_genre] },
  { title: 'The Silence of the Lambs', country: us, language: en, release_date: '1991-02-14', vote_count: 17200, vote_average: 8.3, popularity: 1045.3, genres: [thriller_genre, crime_genre, horror_genre] },
  { title: 'Jurassic Park', country: us, language: en, release_date: '1993-06-11', vote_count: 16900, vote_average: 7.9, popularity: 1234.6, genres: [adventure_genre, scifi_genre, action_genre] },
  { title: 'The Lion King', country: us, language: en, release_date: '1994-06-24', vote_count: 18400, vote_average: 8.3, popularity: 1089.5, genres: [animation_genre, adventure_genre, drama_genre] },
  { title: 'Toy Story', country: us, language: en, release_date: '1995-11-22', vote_count: 17800, vote_average: 8.0, popularity: 945.7, genres: [animation_genre, comedy_genre, adventure_genre] },
  
  # 1980s - 80s classics
  { title: 'Back to the Future', country: us, language: en, release_date: '1985-07-03', vote_count: 21300, vote_average: 8.3, popularity: 1345.8, genres: [scifi_genre, comedy_genre, adventure_genre] },
  { title: 'The Empire Strikes Back', country: us, language: en, release_date: '1980-05-21', vote_count: 18700, vote_average: 8.4, popularity: 1578.4, genres: [scifi_genre, adventure_genre, action_genre] },
  { title: 'Raiders of the Lost Ark', country: us, language: en, release_date: '1981-06-12', vote_count: 12900, vote_average: 7.9, popularity: 1123.6, genres: [action_genre, adventure_genre] },
  { title: 'The Terminator', country: us, language: en, release_date: '1984-10-26', vote_count: 13800, vote_average: 7.7, popularity: 967.4, genres: [scifi_genre, action_genre, thriller_genre] },
  { title: 'Blade Runner', country: us, language: en, release_date: '1982-06-25', vote_count: 15200, vote_average: 7.9, popularity: 1234.2, genres: [scifi_genre, thriller_genre] },
  { title: 'E.T. the Extra-Terrestrial', country: us, language: en, release_date: '1982-06-11', vote_count: 11900, vote_average: 7.5, popularity: 1078.9, genres: [scifi_genre, adventure_genre, fantasy_genre] },
  { title: 'The Shining', country: us, language: en, release_date: '1980-05-23', vote_count: 16700, vote_average: 8.2, popularity: 1456.3, genres: [horror_genre, thriller_genre] },
  
  # 1970s - Cinematic masterpieces
  { title: 'Star Wars', country: us, language: en, release_date: '1977-05-25', vote_count: 20100, vote_average: 8.2, popularity: 1789.6, genres: [scifi_genre, adventure_genre, action_genre] },
  { title: 'The Godfather', country: us, language: en, release_date: '1972-03-24', vote_count: 19800, vote_average: 8.7, popularity: 2134.5, genres: [crime_genre, drama_genre] },
  { title: 'Jaws', country: us, language: en, release_date: '1975-06-20', vote_count: 11200, vote_average: 7.7, popularity: 1234.8, genres: [thriller_genre, horror_genre, adventure_genre] },
  { title: 'Alien', country: us, language: en, release_date: '1979-05-25', vote_count: 14900, vote_average: 8.1, popularity: 1456.9, genres: [horror_genre, scifi_genre, thriller_genre] },
  { title: 'Taxi Driver', country: us, language: en, release_date: '1976-02-09', vote_count: 9800, vote_average: 8.1, popularity: 892.4, genres: [drama_genre, crime_genre] }
]

movies_data.each do |movie_data|
  genres = movie_data.delete(:genres)
  movie = Movie.find_or_create_by!(title: movie_data[:title]) do |m|
    m.production_country = movie_data[:country]
    m.original_language = movie_data[:language]
    m.release_date = movie_data[:release_date]
    m.vote_count = movie_data[:vote_count]
    m.vote_average = movie_data[:vote_average]
    m.popularity = movie_data[:popularity]
    m.overview = "A classic film from the #{movie_data[:release_date][0..3]} era."
    m.tmdb_id = rand(100000..999999) # Random TMDB ID for demo
  end
  
  # Associate genres
  genres.compact.each do |genre|
    MovieGenre.find_or_create_by!(movie: movie, genre: genre)
  end
end

puts "✓ Created #{Movie.count} movies"
puts "✓ Created #{MovieGenre.count} movie-genre associations"

# ===== SUMMARY =====
puts ""
puts "============================================================"
puts "✅ DIVERSE SEEDING COMPLETE!"
puts "============================================================"
puts ""
puts "📊 Summary:"
puts "  - Users: #{User.count}"
puts "  - Movies: #{Movie.count}"
puts "  - Genres: #{Genre.count}"
puts "  - Countries: #{ProductionCountry.count}"
puts "  - Languages: #{OriginalLanguage.count}"
puts "  - Movie-Genre associations: #{MovieGenre.count}"
puts ""
puts "🎬 Movies by Decade:"
['2020s', '2010s', '2000s', '1990s', '1980s', '1970s'].each do |decade|
  start_year = decade[0..3].to_i
  end_year = start_year + 10
  count = Movie.where('release_date >= ? AND release_date < ?', "#{start_year}-01-01", "#{end_year}-01-01").count
  puts "  - #{decade}: #{count} movies"
end
puts ""
puts "🎭 Movies by Genre:"
Genre.all.each do |genre|
  count = genre.movies.count
  puts "  - #{genre.name}: #{count} movies" if count > 0
end
puts ""
puts "🎥 Visit http://localhost:3000 to explore!"
puts ""

