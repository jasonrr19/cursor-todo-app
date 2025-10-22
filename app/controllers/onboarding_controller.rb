# frozen_string_literal: true

class OnboardingController < ApplicationController
  before_action :set_user
  before_action :set_user_preference

  def show
    @step = params[:step]&.to_i || 1
    @total_steps = 6
    
    case @step
    when 1
      @genres = Genre.order(:name)
    when 2
      @languages = OriginalLanguage.where.not(name: 'Unknown').order(:name)
    when 3
      @countries = ProductionCountry.where.not(name: 'Unknown').order(:name)
    when 4
      @decades = [
        { value: '2020s', label: '2020s (2020-present)' },
        { value: '2010s', label: '2010s (2010-2019)' },
        { value: '2000s', label: '2000s (2000-2009)' },
        { value: '1990s', label: '1990s (1990-1999)' },
        { value: '1980s', label: '1980s (1980-1989)' },
        { value: '1970s', label: '1970s (1970-1979)' }
      ]
    when 5
      @people = Person.limit(50).order(:name)
    when 6
      # Final step - show summary
    end
    
    render layout: 'minimal'
  end

  def update
    @step = params[:step]&.to_i || 1
    
    case @step
    when 1
      update_genres
    when 2
      update_language
    when 3
      update_country
    when 4
      update_decades
    when 5
      update_people
    when 6
      complete_onboarding
    end
  end

  private

  def set_user
    # Use current_user from session if logged in, otherwise use first user for demo purposes
    @user = current_user || User.first || User.create!(display_name: 'Demo User', theme_preference: 'system')
    
    # If a new user just signed up and is going through onboarding, make sure we set their session
    session[:user_id] = @user.id if @user && !session[:user_id]
  end

  def set_user_preference
    @user_preference = @user.user_preference || @user.build_user_preference
    
    # Only initialize with empty arrays if this is a new record
    if @user_preference.new_record?
      @user_preference.preferred_genres = []
      @user_preference.preferred_languages = []
      @user_preference.preferred_countries = []
      @user_preference.preferred_decades = []
      @user_preference.preferred_people = []
      @user_preference.save!
    end
  end

  def update_genres
    genre_ids = (params[:genre_ids] || []).reject(&:blank?)
    @user_preference.update!(preferred_genres: genre_ids)
    redirect_to onboarding_path(step: 2)
  end

  def update_language
    language_code = params[:language_code]
    @user_preference.update!(preferred_languages: [language_code]) if language_code.present?
    redirect_to onboarding_path(step: 3)
  end

  def update_country
    country_codes = (params[:country_codes] || []).reject(&:blank?)
    @user_preference.update!(preferred_countries: country_codes)
    redirect_to onboarding_path(step: 4)
  end

  def update_decades
    decades = (params[:decades] || []).reject(&:blank?)
    @user_preference.update!(preferred_decades: decades)
    redirect_to onboarding_path(step: 5)
  end

  def update_people
    person_tmdb_ids = params[:person_tmdb_ids]&.split(',')&.map(&:strip)&.reject(&:blank?) || []
    
    # Find or create Person records by TMDB ID and get their database IDs
    person_ids = []
    person_tmdb_ids.each do |tmdb_id|
      person = Person.find_by(tmdb_id: tmdb_id)
      person_ids << person.id if person
    end
    
    @user_preference.update!(preferred_people: person_ids)
    redirect_to onboarding_path(step: 6)
  end

  def complete_onboarding
    redirect_to recommendations_path, notice: "Welcome to Cinema List Derby, #{@user.display_name}! Here are your personalized recommendations based on your preferences. Feel free to browse and discover movies tailored just for you!"
  end
end
