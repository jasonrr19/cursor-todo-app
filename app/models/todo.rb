# frozen_string_literal: true

class Todo < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :description, presence: true

  scope :completed, -> { where(completed: true) }
  scope :pending, -> { where(completed: false) }

  def toggle!
    update!(completed: !completed)
  end
end
