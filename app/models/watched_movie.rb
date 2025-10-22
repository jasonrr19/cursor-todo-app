class WatchedMovie < ApplicationRecord
  belongs_to :user
  belongs_to :movie

  validates :user_id, uniqueness: { scope: :movie_id }

  scope :recent, -> { order(watched_at: :desc) }
  scope :for_user, ->(user) { where(user: user) }
end

