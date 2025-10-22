# frozen_string_literal: true

class Person < ApplicationRecord
  has_many :movie_people, dependent: :destroy
  has_many :movies, through: :movie_people

  validates :name, presence: true
  validates :tmdb_id, presence: true, uniqueness: true

  scope :directors, -> { where(known_for_department: 'Directing') }
  scope :actors, -> { where(known_for_department: 'Acting') }
  scope :writers, -> { where(known_for_department: 'Writing') }
  
  # Cache person lookup by TMDB ID (expires after 24 hours)
  def self.cached_find_by_tmdb_id(tmdb_id)
    Rails.cache.fetch("people/tmdb/#{tmdb_id}", expires_in: 24.hours) do
      Person.find_by(tmdb_id: tmdb_id)
    end
  end
  
  # Cache person lookup by name (expires after 1 hour since names are searchable)
  def self.cached_search_by_name(name, limit = 10)
    cache_key = "people/search/#{name.downcase}/#{limit}"
    Rails.cache.fetch(cache_key, expires_in: 1.hour) do
      Person.where('LOWER(name) LIKE ?', "%#{name.downcase}%")
            .order(:name)
            .limit(limit)
            .to_a
    end
  end
  
  # Cache popular people by department
  def self.cached_popular_by_department(department, limit = 20)
    cache_key = "people/popular/#{department}/#{limit}"
    Rails.cache.fetch(cache_key, expires_in: 6.hours) do
      Person.where(known_for_department: department)
            .order(:name)
            .limit(limit)
            .to_a
    end
  end
  
  # Clear person cache
  def self.clear_cache
    Person.find_each do |person|
      Rails.cache.delete("people/tmdb/#{person.tmdb_id}")
    end
    # Note: Search caches will expire naturally
  end
end




