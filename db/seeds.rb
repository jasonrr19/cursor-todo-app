# frozen_string_literal: true

# Cinema List Derby - Extensive Seed Data
# Load the extensive seed file with 155+ movies from all genres and eras

load Rails.root.join('db', 'seeds_extensive.rb')

# Clear existing data (optional - comment out if you want to preserve data)
if Rails.env.development? && ENV['CLEAR_DATA'] == 'true'
  puts "⚠️  Clearing existing data..."
  [RecommendationEvent, SearchQuery, Review, ListMovie, List, MoviePerson, MovieGenre, 
   Movie, UserPreference, User, Person, Genre, OriginalLanguage, ProductionCountry].each do |model|
    model.destroy_all
  end
  puts "✓ Data cleared"
  puts ""
end

# ===== STEP 1: Create Core Data =====
puts "📊 Creating core data..."

# Production Countries
countries_data = [
  { name: 'United States of America', iso_3166_1: 'US' },
  { name: 'Japan', iso_3166_1: 'JP' },
  { name: 'South Korea', iso_3166_1: 'KR' },
  { name: 'France', iso_3166_1: 'FR' },
  { name: 'United Kingdom', iso_3166_1: 'GB' },
  { name: 'Spain', iso_3166_1: 'ES' },
  { name: 'Italy', iso_3166_1: 'IT' },
  { name: 'Germany', iso_3166_1: 'DE' },
  { name: 'Mexico', iso_3166_1: 'MX' },
  { name: 'Thailand', iso_3166_1: 'TH' }
]

countries_data.each do |country_data|
  country = ProductionCountry.find_or_initialize_by(iso_3166_1: country_data[:iso_3166_1])
  country.name = country_data[:name]
  country.save!
end
puts "✓ Created #{ProductionCountry.count} countries"

# Languages
languages_data = [
  { name: 'English', iso_639_1: 'en' },
  { name: 'Japanese', iso_639_1: 'ja' },
  { name: 'Korean', iso_639_1: 'ko' },
  { name: 'French', iso_639_1: 'fr' },
  { name: 'Spanish', iso_639_1: 'es' },
  { name: 'Italian', iso_639_1: 'it' },
  { name: 'German', iso_639_1: 'de' },
  { name: 'Thai', iso_639_1: 'th' }
]

languages_data.each do |lang_data|
  lang = OriginalLanguage.find_or_initialize_by(iso_639_1: lang_data[:iso_639_1])
  lang.name = lang_data[:name]
  lang.save!
end
puts "✓ Created #{OriginalLanguage.count} languages"

# Genres
genres_data = [
  { name: 'Horror', tmdb_id: 27 },
  { name: 'Thriller', tmdb_id: 53 },
  { name: 'Drama', tmdb_id: 18 },
  { name: 'Action', tmdb_id: 28 },
  { name: 'Mystery', tmdb_id: 9648 },
  { name: 'Fantasy', tmdb_id: 14 },
  { name: 'Science Fiction', tmdb_id: 878 },
  { name: 'Crime', tmdb_id: 80 },
  { name: 'Romance', tmdb_id: 10749 },
  { name: 'Comedy', tmdb_id: 35 }
]

genres_data.each do |genre_data|
  Genre.find_or_create_by!(tmdb_id: genre_data[:tmdb_id]) do |genre|
    genre.name = genre_data[:name]
  end
end
puts "✓ Created #{Genre.count} genres"

# ===== STEP 2: Create Demo User =====
puts ""
puts "👤 Creating demo user..."

user = User.find_or_create_by!(display_name: 'Cinema Enthusiast') do |u|
  u.theme_preference = 'dark'
end

# User preferences (J-horror fan with international cinema taste)
UserPreference.find_or_create_by!(user: user) do |pref|
  pref.preferred_genres = [27, 53, 18, 9648] # Horror, Thriller, Drama, Mystery
  pref.preferred_decades = ['1990s', '2000s', '2010s']
  pref.preferred_countries = ['JP', 'KR', 'TH', 'US']
  pref.preferred_languages = ['ja', 'ko', 'en']
  pref.preferred_people = []
  pref.serendipity_intensity = 'high'
end

puts "✓ Created user: #{user.display_name}"

# ===== STEP 3: Create People (Directors) =====
puts ""
puts "🎭 Creating directors and actors..."

people_data = [
  { name: 'Takashi Shimizu', tmdb_id: 55636, known_for_department: 'Directing' },
  { name: 'Hideo Nakata', tmdb_id: 55634, known_for_department: 'Directing' },
  { name: 'Kiyoshi Kurosawa', tmdb_id: 55637, known_for_department: 'Directing' },
  { name: 'Takashi Miike', tmdb_id: 8953, known_for_department: 'Directing' },
  { name: 'Park Chan-wook', tmdb_id: 15405, known_for_department: 'Directing' },
  { name: 'Bong Joon-ho', tmdb_id: 21684, known_for_department: 'Directing' },
  { name: 'Guillermo del Toro', tmdb_id: 108916, known_for_department: 'Directing' },
  { name: 'Ari Aster', tmdb_id: 1503200, known_for_department: 'Directing' },
  { name: 'Jordan Peele', tmdb_id: 291263, known_for_department: 'Directing' },
  { name: 'Robert Eggers', tmdb_id: 1178066, known_for_department: 'Directing' }
]

people_data.each do |person_data|
  Person.find_or_create_by!(tmdb_id: person_data[:tmdb_id]) do |person|
    person.name = person_data[:name]
    person.known_for_department = person_data[:known_for_department]
  end
end

puts "✓ Created #{Person.count} people"

# ===== STEP 4: Create Movies =====
puts ""
puts "🎥 Creating demo movies..."

# Helper to get country and language
us = ProductionCountry.find_by(iso_3166_1: 'US')
jp = ProductionCountry.find_by(iso_3166_1: 'JP')
kr = ProductionCountry.find_by(iso_3166_1: 'KR')
en = OriginalLanguage.find_by(iso_639_1: 'en')
ja = OriginalLanguage.find_by(iso_639_1: 'ja')
ko = OriginalLanguage.find_by(iso_639_1: 'ko')

horror = Genre.find_by(tmdb_id: 27)
thriller = Genre.find_by(tmdb_id: 53)
drama = Genre.find_by(tmdb_id: 18)
mystery = Genre.find_by(tmdb_id: 9648)

# Classic J-Horror Movies
movies_data = [
  {
    title: 'Ju-On: The Grudge',
    tmdb_id: 9331,
    overview: 'A mysterious and vengeful spirit marks and pursues anybody who dares enter the house in which it resides.',
    release_date: '2002-10-18',
    vote_average: 6.9,
    vote_count: 850,
    popularity: 45.5,
    runtime: 92,
    country: jp,
    language: ja,
    genres: [horror, thriller],
    director: 'Takashi Shimizu'
  },
  {
    title: 'Ringu',
    tmdb_id: 9323,
    overview: 'A mysterious video has been linked to a number of deaths, and when an inquisitive journalist finds the tape and views it herself, she sets in motion a chain of events that puts her own life in danger.',
    release_date: '1998-01-31',
    vote_average: 7.2,
    vote_count: 1450,
    popularity: 52.3,
    runtime: 96,
    country: jp,
    language: ja,
    genres: [horror, mystery],
    director: 'Hideo Nakata'
  },
  {
    title: 'Pulse',
    tmdb_id: 11695,
    overview: 'Ghosts reach out to the living through the internet in this unsettling Japanese horror film.',
    release_date: '2001-02-03',
    vote_average: 6.5,
    vote_count: 380,
    popularity: 28.7,
    runtime: 119,
    country: jp,
    language: ja,
    genres: [horror, thriller, mystery],
    director: 'Kiyoshi Kurosawa'
  },
  {
    title: 'Audition',
    tmdb_id: 11848,
    overview: 'A widower takes an offer to screen girls at a special audition, arranged for him by a friend to find him a new wife. The one he fancies is not who she appears to be after all.',
    release_date: '1999-03-03',
    vote_average: 7.0,
    vote_count: 720,
    popularity: 35.2,
    runtime: 115,
    country: jp,
    language: ja,
    genres: [horror, drama],
    director: 'Takashi Miike'
  },
  {
    title: 'The Host',
    tmdb_id: 3034,
    overview: 'A monster emerges from the Han River and begins attacking people. One victims loving family does what it can to rescue her from its clutches.',
    release_date: '2006-07-27',
    vote_average: 7.0,
    vote_count: 1850,
    popularity: 42.8,
    runtime: 120,
    country: kr,
    language: ko,
    genres: [horror, drama, thriller],
    director: 'Bong Joon-ho'
  },
  {
    title: 'Oldboy',
    tmdb_id: 670,
    overview: 'After being kidnapped and imprisoned for fifteen years, Oh Dae-Su is released, only to find that he must find his captor in five days.',
    release_date: '2003-11-21',
    vote_average: 8.2,
    vote_count: 5200,
    popularity: 68.9,
    runtime: 120,
    country: kr,
    language: ko,
    genres: [thriller, drama, mystery],
    director: 'Park Chan-wook'
  },
  {
    title: 'Hereditary',
    tmdb_id: 493922,
    overview: 'When Ellen, the matriarch of the Graham family, passes away, her daughter and grandchildren begin to unravel cryptic and increasingly terrifying secrets about their ancestry.',
    release_date: '2018-06-04',
    vote_average: 7.0,
    vote_count: 6500,
    popularity: 89.3,
    runtime: 127,
    country: us,
    language: en,
    genres: [horror, thriller, mystery],
    director: 'Ari Aster'
  },
  {
    title: 'Get Out',
    tmdb_id: 419430,
    overview: 'A young African-American visits his white girlfriend\'s parents for the weekend, where his simmering uneasiness about their reception of him eventually reaches a boiling point.',
    release_date: '2017-02-24',
    vote_average: 7.6,
    vote_count: 12000,
    popularity: 95.7,
    runtime: 104,
    country: us,
    language: en,
    genres: [horror, thriller, mystery],
    director: 'Jordan Peele'
  }
]

movies_data.each do |movie_data|
  movie = Movie.find_or_create_by!(tmdb_id: movie_data[:tmdb_id]) do |m|
    m.title = movie_data[:title]
    m.overview = movie_data[:overview]
    m.release_date = movie_data[:release_date]
    m.vote_average = movie_data[:vote_average]
    m.vote_count = movie_data[:vote_count]
    m.popularity = movie_data[:popularity]
    m.runtime = movie_data[:runtime]
    m.production_country = movie_data[:country]
    m.original_language = movie_data[:language]
  end
  
  # Add genres
  movie_data[:genres].each do |genre|
    MovieGenre.find_or_create_by!(movie: movie, genre: genre)
  end
  
  # Add director
  if movie_data[:director]
    director = Person.find_by(name: movie_data[:director])
    if director
      MoviePerson.find_or_create_by!(movie: movie, person: director, job: 'Director')
    end
  end
end

puts "✓ Created #{Movie.count} movies"

# ===== STEP 5: Create Lists =====
puts ""
puts "📋 Creating demo lists..."

# J-Horror Classics List
j_horror_list = List.find_or_create_by!(
  user: user,
  name: 'J-Horror Essentials (1990s-2000s)'
) do |list|
  list.description = 'The defining films of Japanese horror cinema that changed the genre forever. From cursed videotapes to vengeful spirits, these movies established the atmospheric dread that makes J-horror unique.'
  list.privacy_level = 'public'
end

j_horror_movies = Movie.where(tmdb_id: [9331, 9323, 11695, 11848])
j_horror_movies.each_with_index do |movie, index|
  ListMovie.find_or_create_by!(list: j_horror_list, movie: movie) do |lm|
    lm.position = index
  end
end

# Korean Thrillers List
korean_list = List.find_or_create_by!(
  user: user,
  name: 'Korean Cinema Masterpieces'
) do |list|
  list.description = 'Bold, visceral, and unforgettable Korean films that push boundaries. These directors create cinema that is both beautiful and brutal.'
  list.privacy_level = 'public'
end

korean_movies = Movie.where(tmdb_id: [3034, 670])
korean_movies.each_with_index do |movie, index|
  ListMovie.find_or_create_by!(list: korean_list, movie: movie) do |lm|
    lm.position = index
  end
end

# Modern Horror List
modern_list = List.find_or_create_by!(
  user: user,
  name: 'New Era Horror (2010s+)'
) do |list|
  list.description = 'The new wave of elevated horror that proves the genre can be both terrifying and artistically significant. Smart, atmospheric, and deeply unsettling.'
  list.privacy_level = 'public'
end

modern_movies = Movie.where(tmdb_id: [493922, 419430])
modern_movies.each_with_index do |movie, index|
  ListMovie.find_or_create_by!(list: modern_list, movie: movie) do |lm|
    lm.position = index
  end
end

puts "✓ Created #{List.count} lists"

# ===== STEP 6: Create Sample Reviews =====
puts ""
puts "✍️  Creating sample reviews..."

reviews_data = [
  {
    movie_tmdb_id: 9331,
    rating: 9,
    title: 'The Gold Standard of J-Horror',
    review_text: 'Ju-On perfects the slow-burn dread that defines Japanese horror. The non-linear narrative and the iconic imagery of Kayako crawling down the stairs create an atmosphere of inescapable doom. This isn\'t just scary—it\'s existentially terrifying.',
    contains_spoilers: false
  },
  {
    movie_tmdb_id: 9323,
    rating: 10,
    title: 'Started It All',
    review_text: 'Ringu is the film that launched a thousand imitators but none have matched its simple, elegant terror. The concept of a cursed videotape feels quaint now, but the execution is timeless. Sadako emerging from the TV remains one of cinema\'s most iconic horror moments.',
    contains_spoilers: true
  },
  {
    movie_tmdb_id: 670,
    rating: 10,
    title: 'Revenge Elevated to Art',
    review_text: 'Oldboy is a masterpiece. Park Chan-wook takes a simple revenge story and transforms it into something operatic and tragic. The hallway fight scene alone is worth the price of admission, but it\'s the devastating emotional payoff that makes this unforgettable.',
    contains_spoilers: false
  },
  {
    movie_tmdb_id: 493922,
    rating: 9,
    title: 'Grief as Horror',
    review_text: 'Hereditary uses horror to explore grief and family trauma in ways that are genuinely innovative. Ari Aster\'s debut is relentlessly bleak, but Toni Collette\'s performance grounds the supernatural horror in very real human pain. That dinner scene... you know the one.',
    contains_spoilers: true
  }
]

reviews_data.each do |review_data|
  movie = Movie.find_by(tmdb_id: review_data[:movie_tmdb_id])
  next unless movie
  
  Review.find_or_create_by!(user: user, movie: movie) do |review|
    review.rating = review_data[:rating]
    review.title = review_data[:title]
    review.review_text = review_data[:review_text]
    review.contains_spoilers = review_data[:contains_spoilers]
  end
end

puts "✓ Created #{Review.count} reviews"

# ===== STEP 7: Create Sample Recommendation Events =====
puts ""
puts "📊 Creating sample analytics data..."

# Create some impression events
Movie.limit(5).each do |movie|
  RecommendationEvent.create!(
    user: user,
    movie: movie,
    event_type: 'impression',
    context: {
      source: 'recommendations_index',
      position: Movie.where('id <= ?', movie.id).count - 1,
      timestamp: Time.current.to_i
    }
  )
end

# Create some accept events (user added to list)
j_horror_movies.first(2).each do |movie|
  RecommendationEvent.create!(
    user: user,
    movie: movie,
    event_type: 'accept',
    context: {
      source: 'recommendations_index',
      list_id: j_horror_list.id,
      list_name: j_horror_list.name,
      timestamp: Time.current.to_i
    }
  )
end

puts "✓ Created #{RecommendationEvent.count} recommendation events"

# ===== STEP 8: Create Sample Search Queries =====
puts ""
puts "🔍 Creating sample search history..."

search_queries = [
  { query: 'japanese horror', filters: { genre: '27', language: 'ja' }, results_count: 15 },
  { query: 'park chan-wook', filters: { people: '15405' }, results_count: 8 },
  { query: 'ring', filters: {}, results_count: 42 },
  { query: 'hereditary', filters: { genre: '27' }, results_count: 1 }
]

search_queries.each do |sq_data|
  SearchQuery.create!(
    user: user,
    query: sq_data[:query],
    filters: sq_data[:filters].to_json,
    results_count: sq_data[:results_count]
  )
end

puts "✓ Created #{SearchQuery.count} search queries"

# ===== SUMMARY =====
puts ""
puts "=" * 60
puts "✅ SEEDING COMPLETE!"
puts "=" * 60
puts ""
puts "📊 Summary:"
puts "  - Users: #{User.count}"
puts "  - Movies: #{Movie.count}"
puts "  - Genres: #{Genre.count}"
puts "  - People: #{Person.count}"
puts "  - Lists: #{List.count}"
puts "  - Reviews: #{Review.count}"
puts "  - Countries: #{ProductionCountry.count}"
puts "  - Languages: #{OriginalLanguage.count}"
puts "  - Recommendation Events: #{RecommendationEvent.count}"
puts "  - Search Queries: #{SearchQuery.count}"
puts ""
puts "🎬 Demo User: #{user.display_name}"
puts "   - #{user.lists.count} lists created"
puts "   - #{user.reviews.count} reviews written"
puts "   - Preferences set for J-horror and international cinema"
puts ""
puts "📋 Featured Lists:"
user.lists.each do |list|
  puts "   - #{list.name} (#{list.movies.count} movies)"
end
puts ""
puts "🎥 Visit http://localhost:3000 to explore the demo!"
puts ""


