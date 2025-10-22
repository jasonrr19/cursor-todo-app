# frozen_string_literal: true

class SearchQuery < ApplicationRecord
  belongs_to :user, optional: true

  validates :query, presence: true
  validates :results_count, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :recent, -> { order(created_at: :desc) }
  scope :popular, -> { group(:query).order('COUNT(*) DESC') }
  scope :with_results, -> { where('results_count > 0') }
  scope :empty_results, -> { where(results_count: 0) }

  def filters_applied?
    filters.present? && filters.any?
  end

  def applied_filters
    filters || {}
  end

  def genre_filters
    applied_filters['genres'] || []
  end

  def decade_filters
    applied_filters['decades'] || []
  end

  def country_filters
    applied_filters['countries'] || []
  end

  def language_filters
    applied_filters['languages'] || []
  end

  def person_filters
    filters_hash = applied_filters
    people = filters_hash['people'] || []
    people.is_a?(Array) ? people : []
  end
end




