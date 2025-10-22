# frozen_string_literal: true

class RecommendationEvent < ApplicationRecord
  belongs_to :user
  belongs_to :movie

  validates :event_type, presence: true, inclusion: { in: %w[impression accept dismiss] }
  validates :context, presence: true

  scope :impressions, -> { where(event_type: 'impression') }
  scope :accepts, -> { where(event_type: 'accept') }
  scope :dismissals, -> { where(event_type: 'dismiss') }
  scope :recent, -> { order(created_at: :desc) }

  def serendipity_event?
    context&.dig('serendipity_mode').present?
  end

  def recommendation_source
    context&.dig('source') || 'unknown'
  end
end





