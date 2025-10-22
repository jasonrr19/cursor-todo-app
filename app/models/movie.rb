# frozen_string_literal: true

class Movie < ApplicationRecord
  belongs_to :production_country
  belongs_to :original_language
  has_many :movie_genres, dependent: :destroy
  has_many :genres, through: :movie_genres
  has_many :movie_people, dependent: :destroy
  has_many :people, through: :movie_people
  has_many :list_movies, dependent: :destroy
  has_many :lists, through: :list_movies
  has_many :reviews, dependent: :destroy
  has_many :recommendation_events, dependent: :destroy
  has_many :watched_movies, dependent: :destroy
  has_many :watchers, through: :watched_movies, source: :user

  validates :title, presence: true
  validates :tmdb_id, presence: true, uniqueness: true
  validates :vote_average, presence: true, numericality: { in: 0..10 }
  validates :vote_count, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :by_genre, ->(genre_id) { joins(:genres).where(genres: { id: genre_id }) }
  scope :by_decade, ->(decade) {
    start_year = decade.to_i
    end_year = start_year + 9
    where(release_date: start_year..end_year)
  }
  scope :by_country, ->(country_code) { joins(:production_country).where(production_countries: { iso_3166_1: country_code }) }
  scope :by_language, ->(language_code) { joins(:original_language).where(original_languages: { iso_639_1: language_code }) }
  scope :popular, -> { order(vote_count: :desc) }
  scope :top_rated, -> { order(vote_average: :desc) }
  scope :recent, -> { order(release_date: :desc) }
  
  # Eager-loading scopes to prevent N+1 queries
  scope :with_details, -> { includes(:genres, :production_country, :original_language) }
  scope :with_full_details, -> { includes(:genres, :production_country, :original_language, :people, :reviews) }
  scope :with_people, -> { includes(:people, :movie_people) }

  def directors
    people.joins(:movie_people).where(movie_people: { job: 'Director' })
  end

  def actors
    people.joins(:movie_people).where(movie_people: { job: 'Actor' })
  end

  def writers
    people.joins(:movie_people).where(movie_people: { job: 'Writer' })
  end

  def decade
    return nil unless release_date
    "#{release_date.year / 10 * 10}s"
  end

  def poster_url(size = 'w500')
    if poster_path
      "#{Rails.application.config.tmdb[:image_base_url]}/#{size}#{poster_path}"
    else
      # Generate a placeholder with the movie title and genre colors
      # Use a gradient based on the first genre
      nil
    end
  end

  def backdrop_url(size = 'w1280')
    return nil unless backdrop_path
    "#{Rails.application.config.tmdb[:image_base_url]}/#{size}#{backdrop_path}"
  end
end
