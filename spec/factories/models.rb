# frozen_string_literal: true

FactoryBot.define do
  factory :genre do
    name { Faker::Book.genre }
    tmdb_id { Faker::Number.unique.between(from: 1, to: 1000) }
  end

  factory :production_country do
    name { Faker::Address.country }
    iso_3166_1 { Faker::Address.country_code }
  end

  factory :original_language do
    name { %w[English Japanese French German Spanish].sample }
    iso_639_1 { %w[en ja fr de es].sample }
  end

  factory :person do
    name { Faker::Name.name }
    tmdb_id { Faker::Number.unique.between(from: 1, to: 10000) }
    known_for_department { %w[Acting Directing Writing].sample }
  end

  factory :movie do
    title { Faker::Movie.title }
    tmdb_id { Faker::Number.unique.between(from: 1, to: 100000) }
    release_date { Faker::Date.between(from: 50.years.ago, to: Date.current) }
    vote_average { Faker::Number.between(from: 0.0, to: 10.0) }
    vote_count { Faker::Number.between(from: 0, to: 50000) }
    overview { Faker::Lorem.paragraph }
    poster_path { "/#{Faker::Alphanumeric.alphanumeric(number: 10)}.jpg" }
    backdrop_path { "/#{Faker::Alphanumeric.alphanumeric(number: 10)}.jpg" }
    association :production_country
    association :original_language
  end

  factory :user_preference do
    association :user
    serendipity_intensity { %w[low medium high].sample }
    preferred_genres { [] }
    preferred_languages { [] }
    preferred_countries { [] }
    preferred_decades { [] }
    preferred_people { [] }
  end

  factory :review do
    association :user
    association :movie
    rating { Faker::Number.between(from: 1, to: 10) }
    review_text { Faker::Lorem.paragraph }
  end
end
