# frozen_string_literal: true

class MoviePerson < ApplicationRecord
  belongs_to :movie
  belongs_to :person

  validates :movie_id, uniqueness: { scope: [:person_id, :job] }
  validates :job, presence: true
end





