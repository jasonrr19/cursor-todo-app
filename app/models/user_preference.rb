# frozen_string_literal: true

class UserPreference < ApplicationRecord
  belongs_to :user

  validates :serendipity_intensity, inclusion: { in: %w[low medium high] }

  def preferred_genre_ids
    preferred_genres || []
  end

  def preferred_decade_strings
    preferred_decades || []
  end

  def preferred_country_codes
    preferred_countries || []
  end

  def preferred_language_codes
    preferred_languages || []
  end

  def preferred_person_ids
    preferred_people || []
  end

  def add_preferred_genre(genre_id)
    self.preferred_genres = (preferred_genre_ids + [genre_id]).uniq
  end

  def remove_preferred_genre(genre_id)
    self.preferred_genres = preferred_genre_ids - [genre_id]
  end

  def add_preferred_decade(decade)
    self.preferred_decades = (preferred_decade_strings + [decade]).uniq
  end

  def remove_preferred_decade(decade)
    self.preferred_decades = preferred_decade_strings - [decade]
  end

  def add_preferred_country(country_code)
    self.preferred_countries = (preferred_country_codes + [country_code]).uniq
  end

  def remove_preferred_country(country_code)
    self.preferred_countries = preferred_country_codes - [country_code]
  end

  def add_preferred_language(language_code)
    self.preferred_languages = (preferred_language_codes + [language_code]).uniq
  end

  def remove_preferred_language(language_code)
    self.preferred_languages = preferred_language_codes - [language_code]
  end

  def add_preferred_person(person_id)
    self.preferred_people = (preferred_person_ids + [person_id]).uniq
  end

  def remove_preferred_person(person_id)
    self.preferred_people = preferred_person_ids - [person_id]
  end
end





