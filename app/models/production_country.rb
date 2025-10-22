# frozen_string_literal: true

class ProductionCountry < ApplicationRecord
  has_many :movies, dependent: :destroy

  validates :name, presence: true
  validates :iso_3166_1, presence: true, uniqueness: true
end





