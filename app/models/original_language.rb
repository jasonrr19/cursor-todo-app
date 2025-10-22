# frozen_string_literal: true

class OriginalLanguage < ApplicationRecord
  has_many :movies, dependent: :destroy

  validates :name, presence: true
  validates :iso_639_1, presence: true, uniqueness: true
end





