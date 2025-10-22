# frozen_string_literal: true

# Cinema List Derby - Extensive Seed Data
# Comprehensive collection with 150+ movies across all genres and eras

puts "🎬 Cinema List Derby - Seeding Extensive Movie Collection..."
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

# Production Countries
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
  { name: 'Thailand', iso_3166_1: 'TH' },
  { name: 'New Zealand', iso_3166_1: 'NZ' }
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

# Genres
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

User.find_or_create_by!(display_name: 'Movie Buff') { |u| u.theme_preference = 'dark' }
User.find_or_create_by!(display_name: 'Casual Viewer') { |u| u.theme_preference = 'dark' }
User.find_or_create_by!(display_name: 'Film Student') { |u| u.theme_preference = 'dark' }
puts "✓ Created #{User.count} users"

# ===== STEP 3: Extensive Movie Collection =====
puts ""
puts "🎥 Adding extensive movie collection (150+ films)..."

# Helper references
us = ProductionCountry.find_by(iso_3166_1: 'US')
gb = ProductionCountry.find_by(iso_3166_1: 'GB')
fr = ProductionCountry.find_by(iso_3166_1: 'FR')
de = ProductionCountry.find_by(iso_3166_1: 'DE')
it = ProductionCountry.find_by(iso_3166_1: 'IT')
jp = ProductionCountry.find_by(iso_3166_1: 'JP')
kr = ProductionCountry.find_by(iso_3166_1: 'KR')
cn = ProductionCountry.find_by(iso_3166_1: 'CN')
nz = ProductionCountry.find_by(iso_3166_1: 'NZ')
mx = ProductionCountry.find_by(iso_3166_1: 'MX')

en = OriginalLanguage.find_by(iso_639_1: 'en')
fr_lang = OriginalLanguage.find_by(iso_639_1: 'fr')
de_lang = OriginalLanguage.find_by(iso_639_1: 'de')
it_lang = OriginalLanguage.find_by(iso_639_1: 'it')
ja = OriginalLanguage.find_by(iso_639_1: 'ja')
ko = OriginalLanguage.find_by(iso_639_1: 'ko')
zh = OriginalLanguage.find_by(iso_639_1: 'zh')
es = OriginalLanguage.find_by(iso_639_1: 'es')

# Genres
action_genre = Genre.find_by(name: 'Action')
adventure_genre = Genre.find_by(name: 'Adventure')
animation_genre = Genre.find_by(name: 'Animation')
comedy_genre = Genre.find_by(name: 'Comedy')
crime_genre = Genre.find_by(name: 'Crime')
documentary_genre = Genre.find_by(name: 'Documentary')
drama_genre = Genre.find_by(name: 'Drama')
family_genre = Genre.find_by(name: 'Family')
fantasy_genre = Genre.find_by(name: 'Fantasy')
horror_genre = Genre.find_by(name: 'Horror')
mystery_genre = Genre.find_by(name: 'Mystery')
romance_genre = Genre.find_by(name: 'Romance')
scifi_genre = Genre.find_by(name: 'Science Fiction')
thriller_genre = Genre.find_by(name: 'Thriller')
war_genre = Genre.find_by(name: 'War')
western_genre = Genre.find_by(name: 'Western')

# Comprehensive movie collection (150+ films) with TMDB poster/backdrop paths
movies_data = [
  # ===== 2020s (15 films) =====
  { title: 'Dune', country: us, language: en, release_date: '2021-10-22', vote_count: 12500, vote_average: 7.8, popularity: 825.4, genres: [scifi_genre, adventure_genre], poster_path: '/d5NXSklXo0qyIYkgV94XAgMIckC.jpg', backdrop_path: '/s1FhzhJgeCRhWZjP0Nv6UZZ3KTv.jpg' },
  { title: 'Everything Everywhere All at Once', country: us, language: en, release_date: '2022-03-25', vote_count: 8900, vote_average: 8.1, popularity: 567.2, genres: [scifi_genre, comedy_genre, action_genre], poster_path: '/w3LxiVYdWWRvEVdn5RYq6jIqkb1.jpg', backdrop_path: '/yFLDJm8ZLl6XvGglulVxUugY7eG.jpg' },
  { title: 'The Batman', country: us, language: en, release_date: '2022-03-04', vote_count: 9200, vote_average: 7.7, popularity: 712.8, genres: [crime_genre, mystery_genre, action_genre], poster_path: '/74xTEgt7R36Fpooo50r9T25onhq.jpg', backdrop_path: '/b0PlSFdDwbyK0cf5RxwDpaOJQvQ.jpg' },
  { title: 'Top Gun: Maverick', country: us, language: en, release_date: '2022-05-27', vote_count: 8100, vote_average: 8.3, popularity: 923.5, genres: [action_genre, drama_genre], poster_path: '/62HCnUTziyWcpDaBO2i1DX17ljH.jpg', backdrop_path: '/odJ4hx6g6vBt4lBWKFD1tI8WS4x.jpg' },
  { title: 'Oppenheimer', country: us, language: en, release_date: '2023-07-21', vote_count: 7600, vote_average: 8.4, popularity: 892.1, genres: [drama_genre, thriller_genre], poster_path: '/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg', backdrop_path: '/fm6KqXpk3M2HVveHwCrBSSBaO0V.jpg' },
  { title: 'Spider-Man: No Way Home', country: us, language: en, release_date: '2021-12-17', vote_count: 21400, vote_average: 8.0, popularity: 1345.6, genres: [action_genre, adventure_genre, scifi_genre], poster_path: '/1g0dhYtq4irTY1GPXvft6k4YLjm.jpg', backdrop_path: '/iQFcwSGbZXMkeyKrxbPnwnRo5fl.jpg' },
  { title: 'Dune: Part Two', country: us, language: en, release_date: '2024-03-01', vote_count: 9800, vote_average: 8.5, popularity: 1123.7, genres: [scifi_genre, adventure_genre, action_genre], poster_path: '/1pdfLvkbY9ohJlCjQH2CZjjYVvJ.jpg', backdrop_path: '/xOMo8BRK7PfcJv9JCnx7s5hj0PX.jpg' },
  { title: 'Barbie', country: us, language: en, release_date: '2023-07-21', vote_count: 11200, vote_average: 7.2, popularity: 1456.8, genres: [comedy_genre, adventure_genre, fantasy_genre], poster_path: '/iuFNMS8U5cb6xfzi51Dbkovj7vM.jpg', backdrop_path: '/nHf61UzkfFno5X1ofIhugCPus2R.jpg' },
  { title: 'The Fabelmans', country: us, language: en, release_date: '2022-11-23', vote_count: 3400, vote_average: 7.6, popularity: 234.5, genres: [drama_genre], poster_path: '/d2IywyHQM38mOn78khxb1RzPVtt.jpg', backdrop_path: '/6RCf9jzKxyjblYV4CseayK6bcJo.jpg' },
  { title: 'Avatar: The Way of Water', country: us, language: en, release_date: '2022-12-16', vote_count: 14300, vote_average: 7.6, popularity: 1678.9, genres: [scifi_genre, action_genre, adventure_genre], poster_path: '/t6HIqrRAclMCA60NsSmeqe9RmNV.jpg', backdrop_path: '/s16H6tpK2utvwDtzZ8Qy4qm5Emw.jpg' },
  { title: 'The Northman', country: us, language: en, release_date: '2022-04-22', vote_count: 4200, vote_average: 7.0, popularity: 456.3, genres: [action_genre, adventure_genre, thriller_genre], poster_path: '/zhLKlUaF1SEVenGbo25kT5kXHsZ.jpg', backdrop_path: '/wu1uilmhM4TdluKi2ytfz8gidHf.jpg' },
  { title: 'Nope', country: us, language: en, release_date: '2022-07-22', vote_count: 5600, vote_average: 6.8, popularity: 523.4, genres: [horror_genre, mystery_genre, scifi_genre], poster_path: '/AcKVlWaNVVVFQwro3nLXqPljcYA.jpg', backdrop_path: '/AaV1YIdWKnjAIAOe8UUKBFm327v.jpg' },
  { title: 'The Menu', country: us, language: en, release_date: '2022-11-18', vote_count: 6700, vote_average: 7.2, popularity: 612.5, genres: [thriller_genre, horror_genre, comedy_genre], poster_path: '/v31MsWhF9WFh7Qooq6xSBbmJxoG.jpg', backdrop_path: '/uuA01PTtPombRPvL9dvsBqOBJWm.jpg' },
  { title: 'Killers of the Flower Moon', country: us, language: en, release_date: '2023-10-20', vote_count: 4100, vote_average: 7.6, popularity: 734.2, genres: [crime_genre, drama_genre], poster_path: '/dB6Krk806zeqd0YNp2ngQ9zXteH.jpg', backdrop_path: '/cS1pUmRCWR0JhGZplsXHHb8jtFH.jpg' },
  { title: 'Past Lives', country: us, language: en, release_date: '2023-06-02', vote_count: 3200, vote_average: 7.8, popularity: 312.6, genres: [drama_genre, romance_genre], poster_path: '/k3waqVXSnvCZWfJYNtdamTgTtTA.jpg', backdrop_path: '/8yPSYhooj8nyBbmV3GVdLDwuE7e.jpg' },
  
  # ===== 2010s (30 films) =====
  { title: 'Inception', country: gb, language: en, release_date: '2010-07-16', vote_count: 38089, vote_average: 8.4, popularity: 956.2, genres: [scifi_genre, action_genre, thriller_genre], poster_path: '/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg', backdrop_path: '/s3TBrRGB1iav7gFOCNx3H31MoES.jpg' },
  { title: 'The Social Network', country: us, language: en, release_date: '2010-10-01', vote_count: 12800, vote_average: 7.7, popularity: 445.3, genres: [drama_genre], poster_path: '/n0ybibhJtQ5icDqTp8eRytcIHJx.jpg', backdrop_path: '/3jrWZmgW8JpWbM48s1bMuZXaK0h.jpg' },
  { title: 'Mad Max: Fury Road', country: us, language: en, release_date: '2015-05-15', vote_count: 22300, vote_average: 7.6, popularity: 678.9, genres: [action_genre, adventure_genre, scifi_genre], poster_path: '/8tZYtuWezp8JbcsvHYO0O46tFbo.jpg', backdrop_path: '/tbhdm8UJAb4ViCTsulYFL3lxMCd.jpg' },
  { title: 'Get Out', country: us, language: en, release_date: '2017-02-24', vote_count: 16800, vote_average: 7.6, popularity: 534.7, genres: [horror_genre, thriller_genre, mystery_genre], poster_path: '/tFXcEccSQMf3lfhfXKSU9iRBpa3.jpg', backdrop_path: '/h3Z4UQ7bAfgvW1W7NGKPABJa3gO.jpg' },
  { title: 'Parasite', country: kr, language: ko, release_date: '2019-05-30', vote_count: 17900, vote_average: 8.5, popularity: 892.4, genres: [thriller_genre, drama_genre, comedy_genre], poster_path: '/7IiTTgloJzvGI1TAYymCfbfl3vT.jpg', backdrop_path: '/TU9NIjwzjoKPwQHoHshkFcQUCG.jpg' },
  { title: 'Spider-Man: Into the Spider-Verse', country: us, language: en, release_date: '2018-12-14', vote_count: 19200, vote_average: 8.4, popularity: 745.2, genres: [animation_genre, action_genre, adventure_genre], poster_path: '/iiZZdoQBEYBv6id8su7ImL0oCbD.jpg', backdrop_path: '/uUiId6cG32JSRI6RyBQSvQiJLLe.jpg' },
  { title: 'Interstellar', country: us, language: en, release_date: '2014-11-07', vote_count: 35600, vote_average: 8.4, popularity: 1023.5, genres: [scifi_genre, drama_genre, adventure_genre], poster_path: '/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg', backdrop_path: '/xJHokMbljvjADYdit5fK5VQsXEG.jpg' },
  { title: 'Whiplash', country: us, language: en, release_date: '2014-10-10', vote_count: 14700, vote_average: 8.3, popularity: 456.8, genres: [drama_genre], poster_path: '/7fn624j5lj3xTme2SgiLCeuedmO.jpg', backdrop_path: '/6bbZ6XyvgfjhQwbplnUh1LSj1ky.jpg' },
  { title: 'La La Land', country: us, language: en, release_date: '2016-12-09', vote_count: 16200, vote_average: 7.9, popularity: 823.4, genres: [romance_genre, drama_genre, comedy_genre], poster_path: '/uDO8zWDhfWwoFdKS4fzkUJt0Rf0.jpg', backdrop_path: '/fp6X73r9qg13XPdl6EQcpBESE0d.jpg' },
  { title: 'The Grand Budapest Hotel', country: us, language: en, release_date: '2014-03-07', vote_count: 14500, vote_average: 8.1, popularity: 612.7, genres: [comedy_genre, drama_genre, adventure_genre], poster_path: '/eWdyYQreja6JGCzqHWXpWHDrrPo.jpg', backdrop_path: '/nP5PJ4cXz2L66rvmrfh8CLosZOg.jpg' },
  { title: 'Django Unchained', country: us, language: en, release_date: '2012-12-25', vote_count: 18900, vote_average: 8.2, popularity: 934.6, genres: [western_genre, drama_genre, action_genre], poster_path: '/7oWY8VDWW7thTzWh3OKYRkWUlD5.jpg', backdrop_path: '/2oZklIzUbvZXXzIFzv7Hi68d6xf.jpg' },
  { title: '12 Years a Slave', country: us, language: en, release_date: '2013-11-08', vote_count: 10200, vote_average: 7.9, popularity: 523.8, genres: [drama_genre], poster_path: '/xdANQijuNrJaw1HA61rDccME4Tm.jpg', backdrop_path: '/sJkTt1V4C8OIYqLWb8Uod7nPFaR.jpg' },
  { title: 'Arrival', country: us, language: en, release_date: '2016-11-11', vote_count: 19800, vote_average: 7.6, popularity: 734.9, genres: [scifi_genre, drama_genre, mystery_genre], poster_path: '/x2FJsf1ElAgr63Y3PNPtJrcmpoe.jpg', backdrop_path: '/yIZ1xendyqKvY3FGeeUYUd5X9Mm.jpg' },
  { title: 'Blade Runner 2049', country: us, language: en, release_date: '2017-10-06', vote_count: 15600, vote_average: 7.6, popularity: 812.3, genres: [scifi_genre, thriller_genre, mystery_genre], poster_path: '/gajva2L0rPYkEWjzgFlBXCAVBE5.jpg', backdrop_path: '/ilRyazdMJwN05exqhwK4tMKBYZs.jpg' },
  { title: 'The Wolf of Wall Street', country: us, language: en, release_date: '2013-12-25', vote_count: 21200, vote_average: 8.0, popularity: 1045.7, genres: [crime_genre, drama_genre, comedy_genre], poster_path: '/34m2tygAYBGqA9MXKhRDtzYd4MR.jpg', backdrop_path: '/rP36Rx5RQh0rmY90NWh32TxbSlF.jpg' },
  { title: 'Gone Girl', country: us, language: en, release_date: '2014-10-03', vote_count: 17800, vote_average: 8.0, popularity: 823.6, genres: [mystery_genre, thriller_genre, drama_genre], poster_path: '/lv5xShBIDPe7m4ufdlV0IAc7Avk.jpg', backdrop_path: '/8ZTVqvKDQ8emSGUEMjsS4yHAwrp.jpg' },
  { title: 'The Revenant', country: us, language: en, release_date: '2015-12-25', vote_count: 17200, vote_average: 7.5, popularity: 934.8, genres: [western_genre, drama_genre, adventure_genre], poster_path: '/tSaBkriE7TpbjFoQUFXuikoz0dF.jpg', backdrop_path: '/tFEXy3e5MUtAvjxzcb6RMUDnUYn.jpg' },
  { title: 'Moonlight', country: us, language: en, release_date: '2016-10-21', vote_count: 9800, vote_average: 7.4, popularity: 412.5, genres: [drama_genre], poster_path: '/4911T5FbJ9eD2Faz5Z8L7IvZFZW.jpg', backdrop_path: '/fUE8IZXgIUPCMwUpfxfL29dMi6x.jpg' },
  { title: 'Baby Driver', country: gb, language: en, release_date: '2017-06-28', vote_count: 17600, vote_average: 7.5, popularity: 734.2, genres: [action_genre, crime_genre, thriller_genre], poster_path: '/rmnQ9jKW72bHu8uKlMjPIb2VLMI.jpg', backdrop_path: '/g8oFNZDOCxUZqQzs3hLNjOEm6yq.jpg' },
  { title: 'Coco', country: us, language: en, release_date: '2017-11-22', vote_count: 18700, vote_average: 8.2, popularity: 923.8, genres: [animation_genre, family_genre, adventure_genre, fantasy_genre], poster_path: '/gGEsBPAijhVUFoiNpgZXqRVWJt2.jpg', backdrop_path: '/askg3SMvhqEl4OL52YuvdtY40Yb.jpg' },
  { title: 'Inside Out', country: us, language: en, release_date: '2015-06-19', vote_count: 21300, vote_average: 7.9, popularity: 1023.5, genres: [animation_genre, family_genre, adventure_genre, comedy_genre, drama_genre], poster_path: '/2H1TmgdfNtsKlU9jKdeNyYL5y8T.jpg', backdrop_path: '/j29ekbcLpBvxnGk6LjdTc2EI5SA.jpg' },
  { title: 'Frozen', country: us, language: en, release_date: '2013-11-27', vote_count: 19400, vote_average: 7.3, popularity: 1234.6, genres: [animation_genre, adventure_genre, family_genre, fantasy_genre], poster_path: '/kgwjIb2JDHRhNk13lmSxiClFjVk.jpg', backdrop_path: '/6ZiK44ddPyY2PtZzzPKfLz95R9n.jpg' },
  { title: 'The Avengers', country: us, language: en, release_date: '2012-05-04', vote_count: 31200, vote_average: 7.7, popularity: 1567.8, genres: [action_genre, scifi_genre, adventure_genre], poster_path: '/RYMX2wcKCBAr24UyPD7xwmjaTn.jpg', backdrop_path: '/kwUQFeFXOOpgloMgZaadhzkbTI4.jpg' },
  { title: 'Avengers: Endgame', country: us, language: en, release_date: '2019-04-26', vote_count: 29800, vote_average: 8.3, popularity: 1789.5, genres: [action_genre, adventure_genre, scifi_genre], poster_path: '/or06FN3Dka5tukK1e9sl16pB3iy.jpg', backdrop_path: '/7RyHsO4yDXtBv1zUU3mTpHeQ0d5.jpg' },
  { title: 'Guardians of the Galaxy', country: us, language: en, release_date: '2014-08-01', vote_count: 27900, vote_average: 7.9, popularity: 1345.2, genres: [action_genre, scifi_genre, adventure_genre, comedy_genre], poster_path: '/r7vmZjiyZw9rpJMQJdXpjgiCOk9.jpg', backdrop_path: '/bHarw8xrmQeqf3t8HpuMY7zoK4x.jpg' },
  { title: 'Logan', country: us, language: en, release_date: '2017-03-03', vote_count: 23400, vote_average: 7.8, popularity: 1123.6, genres: [action_genre, drama_genre, scifi_genre], poster_path: '/fnbjcRDYn6YviCcePDnGdyAkYsB.jpg', backdrop_path: '/5pAGnkFYSsFJ99ZxDIYnhQbQFXs.jpg' },
  { title: 'John Wick', country: us, language: en, release_date: '2014-10-24', vote_count: 22100, vote_average: 7.4, popularity: 923.7, genres: [action_genre, thriller_genre], poster_path: '/fZPSd91yGE9fCcCe6OoQr6E3Bev.jpg', backdrop_path: '/umC04Cozevu8nn3JTDJ1pc7PVTn.jpg' },
  { title: 'The Shape of Water', country: us, language: en, release_date: '2017-12-08', vote_count: 12400, vote_average: 7.3, popularity: 612.9, genres: [fantasy_genre, drama_genre, romance_genre], poster_path: '/9zfwPffUXpBrEP26yp0q1ckXDcj.jpg', backdrop_path: '/qHYUiqbEjWfMqjyVhwzqTsrJCL5.jpg' },
  { title: 'A Quiet Place', country: us, language: en, release_date: '2018-04-06', vote_count: 19800, vote_average: 7.4, popularity: 834.5, genres: [horror_genre, thriller_genre, drama_genre], poster_path: '/nAU74GmpUk7t5iklEp3bufwDq4n.jpg', backdrop_path: '/roYyPiQDQKmIKUEhO912693tSja.jpg' },
  { title: 'Her', country: us, language: en, release_date: '2013-12-18', vote_count: 14200, vote_average: 7.9, popularity: 534.8, genres: [scifi_genre, romance_genre, drama_genre], poster_path: '/lEIaL12hSkqqe83kgADkbUqEnvk.jpg', backdrop_path: '/bS1TIXFL6cxEk7XMmXd9rIDG4Sc.jpg' },
  
  # ===== 2000s (30 films) =====
  { title: 'The Dark Knight', country: us, language: en, release_date: '2008-07-18', vote_count: 32900, vote_average: 9.0, popularity: 1245.6, genres: [action_genre, crime_genre, thriller_genre] },
  { title: 'WALL-E', country: us, language: en, release_date: '2008-06-27', vote_count: 18500, vote_average: 8.1, popularity: 623.4, genres: [animation_genre, scifi_genre, adventure_genre] },
  { title: 'Amélie', country: fr, language: fr_lang, release_date: '2001-04-25', vote_count: 13200, vote_average: 7.9, popularity: 512.7, genres: [comedy_genre, romance_genre] },
  { title: 'Spirited Away', country: jp, language: ja, release_date: '2001-07-20', vote_count: 16800, vote_average: 8.5, popularity: 892.3, genres: [animation_genre, adventure_genre, fantasy_genre] },
  { title: 'The Lord of the Rings: The Return of the King', country: nz, language: en, release_date: '2003-12-17', vote_count: 28900, vote_average: 8.5, popularity: 1134.2, genres: [adventure_genre, fantasy_genre, action_genre] },
  { title: 'The Lord of the Rings: The Fellowship of the Ring', country: nz, language: en, release_date: '2001-12-19', vote_count: 27600, vote_average: 8.4, popularity: 1089.5, genres: [adventure_genre, fantasy_genre, action_genre] },
  { title: 'The Lord of the Rings: The Two Towers', country: nz, language: en, release_date: '2002-12-18', vote_count: 25800, vote_average: 8.4, popularity: 1023.7, genres: [adventure_genre, fantasy_genre, action_genre] },
  { title: 'Finding Nemo', country: us, language: en, release_date: '2003-05-30', vote_count: 19700, vote_average: 7.8, popularity: 734.5, genres: [animation_genre, adventure_genre, comedy_genre, family_genre] },
  { title: 'Eternal Sunshine of the Spotless Mind', country: us, language: en, release_date: '2004-03-19', vote_count: 11400, vote_average: 8.1, popularity: 478.9, genres: [drama_genre, romance_genre, scifi_genre] },
  { title: 'The Prestige', country: us, language: en, release_date: '2006-10-20', vote_count: 15900, vote_average: 8.5, popularity: 734.2, genres: [drama_genre, mystery_genre, thriller_genre] },
  { title: 'Pan\'s Labyrinth', country: mx, language: es, release_date: '2006-10-11', vote_count: 14200, vote_average: 7.8, popularity: 623.5, genres: [fantasy_genre, drama_genre, war_genre] },
  { title: 'There Will Be Blood', country: us, language: en, release_date: '2007-12-26', vote_count: 8900, vote_average: 8.1, popularity: 512.8, genres: [drama_genre] },
  { title: 'No Country for Old Men', country: us, language: en, release_date: '2007-11-21', vote_count: 12700, vote_average: 8.1, popularity: 634.9, genres: [crime_genre, thriller_genre, western_genre] },
  { title: 'Gladiator', country: us, language: en, release_date: '2000-05-05', vote_count: 17800, vote_average: 8.2, popularity: 1023.6, genres: [action_genre, adventure_genre, drama_genre] },
  { title: 'Memento', country: us, language: en, release_date: '2000-10-11', vote_count: 13400, vote_average: 8.4, popularity: 623.7, genres: [mystery_genre, thriller_genre] },
  { title: 'The Departed', country: us, language: en, release_date: '2006-10-06', vote_count: 14900, vote_average: 8.2, popularity: 823.9, genres: [crime_genre, drama_genre, thriller_genre] },
  { title: 'Casino Royale', country: gb, language: en, release_date: '2006-11-17', vote_count: 11800, vote_average: 7.6, popularity: 934.5, genres: [action_genre, thriller_genre, adventure_genre] },
  { title: 'The Incredibles', country: us, language: en, release_date: '2004-11-05', vote_count: 18200, vote_average: 7.7, popularity: 823.6, genres: [animation_genre, action_genre, adventure_genre, family_genre] },
  { title: 'Ratatouille', country: us, language: en, release_date: '2007-06-29', vote_count: 15600, vote_average: 7.8, popularity: 734.8, genres: [animation_genre, comedy_genre, family_genre, adventure_genre] },
  { title: 'Up', country: us, language: en, release_date: '2009-05-29', vote_count: 18900, vote_average: 7.9, popularity: 923.7, genres: [animation_genre, adventure_genre, comedy_genre, family_genre] },
  { title: 'The Bourne Ultimatum', country: us, language: en, release_date: '2007-08-03', vote_count: 11200, vote_average: 7.4, popularity: 612.8, genres: [action_genre, thriller_genre, mystery_genre] },
  { title: '28 Days Later', country: gb, language: en, release_date: '2002-11-01', vote_count: 8700, vote_average: 7.2, popularity: 534.6, genres: [horror_genre, scifi_genre, thriller_genre] },
  { title: 'Shaun of the Dead', country: gb, language: en, release_date: '2004-04-09', vote_count: 11600, vote_average: 7.5, popularity: 612.9, genres: [horror_genre, comedy_genre] },
  { title: 'Hot Fuzz', country: gb, language: en, release_date: '2007-02-17', vote_count: 10800, vote_average: 7.6, popularity: 534.7, genres: [action_genre, comedy_genre, mystery_genre] },
  { title: 'Oldboy', country: kr, language: ko, release_date: '2003-11-21', vote_count: 9200, vote_average: 8.3, popularity: 623.8, genres: [thriller_genre, mystery_genre, drama_genre] },
  { title: 'Children of Men', country: us, language: en, release_date: '2006-09-22', vote_count: 8900, vote_average: 7.6, popularity: 512.6, genres: [thriller_genre, scifi_genre, drama_genre] },
  { title: 'V for Vendetta', country: us, language: en, release_date: '2006-03-17', vote_count: 14300, vote_average: 7.9, popularity: 834.9, genres: [action_genre, thriller_genre, scifi_genre] },
  { title: 'Howl\'s Moving Castle', country: jp, language: ja, release_date: '2004-11-20', vote_count: 8900, vote_average: 8.4, popularity: 723.5, genres: [animation_genre, fantasy_genre, adventure_genre] },
  { title: 'Zombieland', country: us, language: en, release_date: '2009-10-07', vote_count: 15200, vote_average: 7.5, popularity: 734.8, genres: [comedy_genre, horror_genre, action_genre] },
  { title: 'District 9', country: us, language: en, release_date: '2009-08-14', vote_count: 13700, vote_average: 7.4, popularity: 623.9, genres: [scifi_genre, thriller_genre, action_genre] },
  
  # ===== 1990s (30 films) =====
  { title: 'The Shawshank Redemption', country: us, language: en, release_date: '1994-09-23', vote_count: 27800, vote_average: 8.7, popularity: 1456.8, genres: [drama_genre, crime_genre] },
  { title: 'Pulp Fiction', country: us, language: en, release_date: '1994-10-14', vote_count: 29100, vote_average: 8.5, popularity: 1289.4, genres: [crime_genre, thriller_genre] },
  { title: 'The Matrix', country: us, language: en, release_date: '1999-03-31', vote_count: 26300, vote_average: 8.2, popularity: 1567.2, genres: [scifi_genre, action_genre] },
  { title: 'Goodfellas', country: us, language: en, release_date: '1990-09-19', vote_count: 14600, vote_average: 8.5, popularity: 923.7, genres: [crime_genre, drama_genre] },
  { title: 'The Silence of the Lambs', country: us, language: en, release_date: '1991-02-14', vote_count: 17200, vote_average: 8.3, popularity: 1045.3, genres: [thriller_genre, crime_genre, horror_genre] },
  { title: 'Jurassic Park', country: us, language: en, release_date: '1993-06-11', vote_count: 16900, vote_average: 7.9, popularity: 1234.6, genres: [adventure_genre, scifi_genre, action_genre] },
  { title: 'The Lion King', country: us, language: en, release_date: '1994-06-24', vote_count: 18400, vote_average: 8.3, popularity: 1089.5, genres: [animation_genre, adventure_genre, drama_genre, family_genre] },
  { title: 'Toy Story', country: us, language: en, release_date: '1995-11-22', vote_count: 17800, vote_average: 8.0, popularity: 945.7, genres: [animation_genre, comedy_genre, adventure_genre, family_genre] },
  { title: 'Forrest Gump', country: us, language: en, release_date: '1994-07-06', vote_count: 29600, vote_average: 8.5, popularity: 1345.8, genres: [drama_genre, romance_genre, comedy_genre] },
  { title: 'Fight Club', country: us, language: en, release_date: '1999-10-15', vote_count: 32100, vote_average: 8.4, popularity: 1456.9, genres: [drama_genre, thriller_genre] },
  { title: 'The Big Lebowski', country: us, language: en, release_date: '1998-03-06', vote_count: 11800, vote_average: 7.8, popularity: 823.6, genres: [comedy_genre, crime_genre, mystery_genre] },
  { title: 'Schindler\'s List', country: us, language: en, release_date: '1993-12-15', vote_count: 16200, vote_average: 8.9, popularity: 1123.5, genres: [drama_genre, war_genre] },
  { title: 'Saving Private Ryan', country: us, language: en, release_date: '1998-07-24', vote_count: 17900, vote_average: 8.2, popularity: 1034.7, genres: [war_genre, drama_genre, action_genre] },
  { title: 'The Green Mile', country: us, language: en, release_date: '1999-12-10', vote_count: 18200, vote_average: 8.5, popularity: 934.8, genres: [drama_genre, crime_genre, fantasy_genre] },
  { title: 'Reservoir Dogs', country: us, language: en, release_date: '1992-09-02', vote_count: 9800, vote_average: 8.2, popularity: 723.6, genres: [crime_genre, thriller_genre] },
  { title: 'American Beauty', country: us, language: en, release_date: '1999-09-15', vote_count: 13400, vote_average: 8.0, popularity: 834.9, genres: [drama_genre] },
  { title: 'Titanic', country: us, language: en, release_date: '1997-12-19', vote_count: 27800, vote_average: 7.9, popularity: 1678.4, genres: [romance_genre, drama_genre] },
  { title: 'Terminator 2: Judgment Day', country: us, language: en, release_date: '1991-07-03', vote_count: 14900, vote_average: 8.1, popularity: 1234.7, genres: [scifi_genre, action_genre, thriller_genre] },
  { title: 'The Truman Show', country: us, language: en, release_date: '1998-06-05', vote_count: 11700, vote_average: 8.1, popularity: 723.8, genres: [scifi_genre, comedy_genre, drama_genre] },
  { title: 'The Sixth Sense', country: us, language: en, release_date: '1999-08-06', vote_count: 9800, vote_average: 7.9, popularity: 834.6, genres: [mystery_genre, thriller_genre, drama_genre] },
  { title: 'Seven', country: us, language: en, release_date: '1995-09-22', vote_count: 16700, vote_average: 8.3, popularity: 1023.9, genres: [crime_genre, thriller_genre, mystery_genre] },
  { title: 'L.A. Confidential', country: us, language: en, release_date: '1997-09-19', vote_count: 7200, vote_average: 7.8, popularity: 612.7, genres: [crime_genre, mystery_genre, thriller_genre] },
  { title: 'The Usual Suspects', country: us, language: en, release_date: '1995-08-16', vote_count: 12400, vote_average: 8.5, popularity: 834.9, genres: [crime_genre, thriller_genre, mystery_genre] },
  { title: 'Toy Story 2', country: us, language: en, release_date: '1999-11-24', vote_count: 13200, vote_average: 7.6, popularity: 734.5, genres: [animation_genre, comedy_genre, family_genre, adventure_genre] },
  { title: 'Princess Mononoke', country: jp, language: ja, release_date: '1997-07-12', vote_count: 8900, vote_average: 8.3, popularity: 623.7, genres: [animation_genre, adventure_genre, fantasy_genre] },
  { title: 'Fargo', country: us, language: en, release_date: '1996-03-08', vote_count: 8600, vote_average: 8.0, popularity: 534.8, genres: [crime_genre, drama_genre, thriller_genre] },
  { title: 'The Iron Giant', country: us, language: en, release_date: '1999-08-06', vote_count: 6800, vote_average: 7.9, popularity: 456.7, genres: [animation_genre, family_genre, scifi_genre, adventure_genre] },
  { title: 'Heat', country: us, language: en, release_date: '1995-12-15', vote_count: 8300, vote_average: 7.9, popularity: 723.6, genres: [crime_genre, action_genre, thriller_genre] },
  { title: 'The Nightmare Before Christmas', country: us, language: en, release_date: '1993-10-29', vote_count: 8700, vote_average: 7.8, popularity: 623.9, genres: [animation_genre, fantasy_genre, family_genre] },
  { title: 'Scream', country: us, language: en, release_date: '1996-12-20', vote_count: 12300, vote_average: 7.4, popularity: 734.8, genres: [horror_genre, mystery_genre] },
  
  # ===== 1980s (30 films) =====
  { title: 'Back to the Future', country: us, language: en, release_date: '1985-07-03', vote_count: 21300, vote_average: 8.3, popularity: 1345.8, genres: [scifi_genre, comedy_genre, adventure_genre] },
  { title: 'The Empire Strikes Back', country: us, language: en, release_date: '1980-05-21', vote_count: 18700, vote_average: 8.4, popularity: 1578.4, genres: [scifi_genre, adventure_genre, action_genre] },
  { title: 'Raiders of the Lost Ark', country: us, language: en, release_date: '1981-06-12', vote_count: 12900, vote_average: 7.9, popularity: 1123.6, genres: [action_genre, adventure_genre] },
  { title: 'The Terminator', country: us, language: en, release_date: '1984-10-26', vote_count: 13800, vote_average: 7.7, popularity: 967.4, genres: [scifi_genre, action_genre, thriller_genre] },
  { title: 'Blade Runner', country: us, language: en, release_date: '1982-06-25', vote_count: 15200, vote_average: 7.9, popularity: 1234.2, genres: [scifi_genre, thriller_genre] },
  { title: 'E.T. the Extra-Terrestrial', country: us, language: en, release_date: '1982-06-11', vote_count: 11900, vote_average: 7.5, popularity: 1078.9, genres: [scifi_genre, adventure_genre, fantasy_genre, family_genre] },
  { title: 'The Shining', country: us, language: en, release_date: '1980-05-23', vote_count: 16700, vote_average: 8.2, popularity: 1456.3, genres: [horror_genre, thriller_genre] },
  { title: 'Return of the Jedi', country: us, language: en, release_date: '1983-05-25', vote_count: 14200, vote_average: 7.9, popularity: 1234.5, genres: [scifi_genre, action_genre, adventure_genre] },
  { title: 'Die Hard', country: us, language: en, release_date: '1988-07-15', vote_count: 12800, vote_average: 7.8, popularity: 1045.6, genres: [action_genre, thriller_genre] },
  { title: 'Aliens', country: us, language: en, release_date: '1986-07-18', vote_count: 13900, vote_average: 7.9, popularity: 1123.7, genres: [scifi_genre, action_genre, horror_genre] },
  { title: 'The Thing', country: us, language: en, release_date: '1982-06-25', vote_count: 8700, vote_average: 8.1, popularity: 734.5, genres: [horror_genre, scifi_genre, mystery_genre] },
  { title: 'Full Metal Jacket', country: us, language: en, release_date: '1987-06-26', vote_count: 9200, vote_average: 8.1, popularity: 723.8, genres: [war_genre, drama_genre] },
  { title: 'The Breakfast Club', country: us, language: en, release_date: '1985-02-15', vote_count: 8900, vote_average: 7.8, popularity: 634.7, genres: [comedy_genre, drama_genre] },
  { title: 'Stand by Me', country: us, language: en, release_date: '1986-08-08', vote_count: 9600, vote_average: 7.9, popularity: 623.9, genres: [adventure_genre, drama_genre] },
  { title: 'Ghostbusters', country: us, language: en, release_date: '1984-06-08', vote_count: 11200, vote_average: 7.8, popularity: 934.8, genres: [comedy_genre, fantasy_genre, action_genre] },
  { title: 'The Princess Bride', country: us, language: en, release_date: '1987-10-09', vote_count: 10400, vote_average: 7.7, popularity: 734.6, genres: [adventure_genre, family_genre, fantasy_genre, comedy_genre, romance_genre] },
  { title: 'My Neighbor Totoro', country: jp, language: ja, release_date: '1988-04-16', vote_count: 7800, vote_average: 8.1, popularity: 623.7, genres: [animation_genre, family_genre, fantasy_genre] },
  { title: 'Grave of the Fireflies', country: jp, language: ja, release_date: '1988-04-16', vote_count: 6200, vote_average: 8.5, popularity: 512.8, genres: [animation_genre, drama_genre, war_genre] },
  { title: 'Cinema Paradiso', country: it, language: it_lang, release_date: '1988-11-17', vote_count: 4800, vote_average: 8.4, popularity: 423.6, genres: [drama_genre, romance_genre] },
  { title: 'The Goonies', country: us, language: en, release_date: '1985-06-07', vote_count: 8200, vote_average: 7.5, popularity: 723.8, genres: [adventure_genre, comedy_genre, family_genre] },
  { title: 'Akira', country: jp, language: ja, release_date: '1988-07-16', vote_count: 5900, vote_average: 8.0, popularity: 634.7, genres: [animation_genre, scifi_genre, action_genre] },
  { title: 'Scarface', country: us, language: en, release_date: '1983-12-09', vote_count: 9800, vote_average: 8.0, popularity: 923.8, genres: [crime_genre, action_genre, drama_genre] },
  { title: 'The Evil Dead', country: us, language: en, release_date: '1981-10-15', vote_count: 5200, vote_average: 7.4, popularity: 512.9, genres: [horror_genre, fantasy_genre] },
  { title: 'Raging Bull', country: us, language: en, release_date: '1980-11-14', vote_count: 6700, vote_average: 8.0, popularity: 534.8, genres: [drama_genre] },
  { title: 'Amadeus', country: us, language: en, release_date: '1984-09-19', vote_count: 7200, vote_average: 8.4, popularity: 623.7, genres: [drama_genre] },
  { title: 'The Untouchables', country: us, language: en, release_date: '1987-06-03', vote_count: 7800, vote_average: 7.8, popularity: 634.9, genres: [crime_genre, thriller_genre, drama_genre] },
  { title: 'Platoon', country: us, language: en, release_date: '1986-12-19', vote_count: 6900, vote_average: 7.7, popularity: 523.6, genres: [war_genre, drama_genre, action_genre] },
  { title: 'Indiana Jones and the Last Crusade', country: us, language: en, release_date: '1989-05-24', vote_count: 10200, vote_average: 7.9, popularity: 934.7, genres: [action_genre, adventure_genre] },
  { title: 'Lethal Weapon', country: us, language: en, release_date: '1987-03-06', vote_count: 8100, vote_average: 7.5, popularity: 723.8, genres: [action_genre, crime_genre, thriller_genre] },
  { title: 'Predator', country: us, language: en, release_date: '1987-06-12', vote_count: 9200, vote_average: 7.5, popularity: 834.6, genres: [scifi_genre, action_genre, thriller_genre] },
  
  # ===== 1970s (20 films) =====
  { title: 'Star Wars', country: us, language: en, release_date: '1977-05-25', vote_count: 20100, vote_average: 8.2, popularity: 1789.6, genres: [scifi_genre, adventure_genre, action_genre] },
  { title: 'The Godfather', country: us, language: en, release_date: '1972-03-24', vote_count: 19800, vote_average: 8.7, popularity: 2134.5, genres: [crime_genre, drama_genre] },
  { title: 'The Godfather Part II', country: us, language: en, release_date: '1974-12-20', vote_count: 14200, vote_average: 8.6, popularity: 1567.8, genres: [crime_genre, drama_genre] },
  { title: 'Jaws', country: us, language: en, release_date: '1975-06-20', vote_count: 11200, vote_average: 7.7, popularity: 1234.8, genres: [thriller_genre, horror_genre, adventure_genre] },
  { title: 'Alien', country: us, language: en, release_date: '1979-05-25', vote_count: 14900, vote_average: 8.1, popularity: 1456.9, genres: [horror_genre, scifi_genre, thriller_genre] },
  { title: 'Taxi Driver', country: us, language: en, release_date: '1976-02-09', vote_count: 9800, vote_average: 8.1, popularity: 892.4, genres: [drama_genre, crime_genre] },
  { title: 'One Flew Over the Cuckoo\'s Nest', country: us, language: en, release_date: '1975-11-19', vote_count: 13700, vote_average: 8.4, popularity: 1023.6, genres: [drama_genre] },
  { title: 'Apocalypse Now', country: us, language: en, release_date: '1979-08-15', vote_count: 10800, vote_average: 8.3, popularity: 923.7, genres: [war_genre, drama_genre] },
  { title: 'Rocky', country: us, language: en, release_date: '1976-11-21', vote_count: 8900, vote_average: 7.8, popularity: 723.8, genres: [drama_genre] },
  { title: 'A Clockwork Orange', country: gb, language: en, release_date: '1971-12-19', vote_count: 12400, vote_average: 8.2, popularity: 1034.9, genres: [scifi_genre, crime_genre, drama_genre] },
  { title: 'Chinatown', country: us, language: en, release_date: '1974-06-20', vote_count: 8200, vote_average: 7.9, popularity: 723.6, genres: [crime_genre, drama_genre, mystery_genre, thriller_genre] },
  { title: 'The Exorcist', country: us, language: en, release_date: '1973-12-26', vote_count: 10200, vote_average: 7.7, popularity: 934.7, genres: [horror_genre] },
  { title: 'The Deer Hunter', country: us, language: en, release_date: '1978-12-08', vote_count: 6700, vote_average: 8.0, popularity: 612.8, genres: [war_genre, drama_genre] },
  { title: 'Annie Hall', country: us, language: en, release_date: '1977-04-20', vote_count: 6200, vote_average: 7.7, popularity: 523.7, genres: [comedy_genre, romance_genre, drama_genre] },
  { title: 'Monty Python and the Holy Grail', country: gb, language: en, release_date: '1975-05-25', vote_count: 9800, vote_average: 7.8, popularity: 734.8, genres: [comedy_genre, adventure_genre, fantasy_genre] },
  { title: 'Carrie', country: us, language: en, release_date: '1976-11-03', vote_count: 5800, vote_average: 7.3, popularity: 512.9, genres: [horror_genre] },
  { title: 'Superman', country: us, language: en, release_date: '1978-12-15', vote_count: 6900, vote_average: 7.1, popularity: 723.6, genres: [scifi_genre, action_genre, adventure_genre] },
  { title: 'Close Encounters of the Third Kind', country: us, language: en, release_date: '1977-11-16', vote_count: 7100, vote_average: 7.4, popularity: 623.8, genres: [scifi_genre, drama_genre] },
  { title: 'Halloween', country: us, language: en, release_date: '1978-10-25', vote_count: 7800, vote_average: 7.6, popularity: 834.9, genres: [horror_genre, thriller_genre] },
  { title: 'Network', country: us, language: en, release_date: '1976-11-27', vote_count: 4200, vote_average: 7.8, popularity: 412.7, genres: [drama_genre] }
]

# Create movies with genre associations
movies_data.each do |movie_data|
  genres = movie_data.delete(:genres)
  movie = Movie.find_or_create_by!(title: movie_data[:title]) do |m|
    m.production_country = movie_data[:country]
    m.original_language = movie_data[:language]
    m.release_date = movie_data[:release_date]
    m.vote_count = movie_data[:vote_count]
    m.vote_average = movie_data[:vote_average]
    m.popularity = movie_data[:popularity]
    m.overview = "A critically acclaimed film from #{movie_data[:release_date][0..3]}."
    m.tmdb_id = rand(100000..999999)
    m.poster_path = movie_data[:poster_path]
    m.backdrop_path = movie_data[:backdrop_path]
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
puts "✅ EXTENSIVE SEEDING COMPLETE!"
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

