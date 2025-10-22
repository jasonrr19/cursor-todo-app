# frozen_string_literal: true

class List < ApplicationRecord
  belongs_to :user
  has_many :list_movies, dependent: :destroy
  has_many :movies, through: :list_movies

  validates :name, presence: true
  validates :privacy_level, presence: true, inclusion: { in: %w[private unlisted public] }
  validate :list_limit_per_user

  scope :public_lists, -> { where(privacy_level: 'public') }
  scope :by_user, ->(user) { where(user: user) }
  
  # Eager-loading scopes
  scope :with_movies, -> { includes(:movies, :list_movies) }
  scope :with_full_details, -> { includes(:movies, :list_movies, :user, movies: [:genres, :production_country, :original_language]) }

  def movies_count
    movies.count
  end

  private

  def list_limit_per_user
    return unless user_id

    if user.lists.count >= 100
      errors.add(:base, 'Maximum of 100 lists per user allowed')
    end
  end
end



