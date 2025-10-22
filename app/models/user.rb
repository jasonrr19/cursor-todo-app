# frozen_string_literal: true

class User < ApplicationRecord
  has_many :todos, dependent: :destroy
  has_one :user_preference, dependent: :destroy
  has_many :lists, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :recommendation_events, dependent: :destroy
  has_many :search_queries, dependent: :destroy
  has_many :watched_movies, dependent: :destroy
  has_many :watched_movie_records, through: :watched_movies, source: :movie

  validates :display_name, presence: true
  validates :theme_preference, inclusion: { in: %w[system light dark] }

  after_create :create_user_preference
  
  # Eager-loading scopes
  scope :with_preferences, -> { includes(:user_preference) }
  scope :with_full_data, -> { includes(:user_preference, :lists, :reviews, :watched_movies, lists: [:movies]) }

  # Check if user has watched a movie
  def watched?(movie)
    watched_movies.exists?(movie: movie)
  end

  # Mark movie as watched
  def mark_as_watched(movie)
    watched_movies.find_or_create_by(movie: movie) do |wm|
      wm.watched_at = Time.current
    end
  end

  # Unmark movie as watched
  def unmark_as_watched(movie)
    watched_movies.where(movie: movie).destroy_all
  end

  private

  def create_user_preference
    build_user_preference.save!
  end
end
