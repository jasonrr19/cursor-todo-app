# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to :user
  belongs_to :movie

  validates :rating, presence: true, numericality: { in: 1..10 }
  validates :user_id, uniqueness: { scope: :movie_id, message: 'can only review a movie once' }
  validates :review_text, length: { maximum: 1000 }

  scope :by_rating, ->(rating) { where(rating: rating) }
  scope :recent, -> { order(created_at: :desc) }

  def edited?
    edited_at.present?
  end

  def edit_count_display
    return 'Original' if edit_count.zero?
    "#{edit_count} edit#{'s' if edit_count > 1}"
  end
end





