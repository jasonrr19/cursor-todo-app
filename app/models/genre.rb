# frozen_string_literal: true

class Genre < ApplicationRecord
  has_many :movie_genres, dependent: :destroy
  has_many :movies, through: :movie_genres

  validates :name, presence: true
  validates :tmdb_id, presence: true, uniqueness: true
  
  # Cache all genres for 24 hours since they rarely change
  def self.cached_all
    Rails.cache.fetch('genres/all', expires_in: 24.hours) do
      Genre.order(:name).to_a
    end
  end
  
  # Cache genre lookup by TMDB ID
  def self.cached_find_by_tmdb_id(tmdb_id)
    Rails.cache.fetch("genres/tmdb/#{tmdb_id}", expires_in: 24.hours) do
      Genre.find_by(tmdb_id: tmdb_id)
    end
  end
  
  # Cache genre lookup by name
  def self.cached_find_by_name(name)
    Rails.cache.fetch("genres/name/#{name.downcase}", expires_in: 24.hours) do
      Genre.find_by('LOWER(name) = ?', name.downcase)
    end
  end
  
  # Clear all genre caches
  def self.clear_cache
    Rails.cache.delete('genres/all')
    Genre.find_each do |genre|
      Rails.cache.delete("genres/tmdb/#{genre.tmdb_id}")
      Rails.cache.delete("genres/name/#{genre.name.downcase}")
    end
  end
end




