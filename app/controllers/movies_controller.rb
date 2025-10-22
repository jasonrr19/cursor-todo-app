# frozen_string_literal: true

class MoviesController < ApplicationController
  before_action :set_search_service

  def search
    query = params[:q]&.strip
    return render json: { success: false, error: 'Query required' } if query.blank?

    page = params[:page]&.to_i || 1
    page = 1 if page < 1

    filters = {
      year: params[:year],
      genre: params[:genre],
      language: params[:language],
      country: params[:country],
      people: params[:people]&.split(',')&.map(&:strip)
    }.compact

    result = @search_service.search(query, filters, page: page)
    render json: result
  end

  def search_people
    query = params[:q]&.strip
    return render json: { success: false, error: 'Query required' } if query.blank?

    limit = params[:limit]&.to_i || 10
    result = @search_service.search_people(query, limit)
    render json: result
  end

  def show
    @movie = Movie.find(params[:id])
    @movie_people = @movie.movie_people.includes(:person).group_by(&:job)
    @user = current_user
    @user_review = @user.reviews.find_by(movie: @movie) if @user
    @watched = @user&.watched?(@movie)
    
    render layout: 'minimal'
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'Movie not found'
  end

  def genres
    genres = Genre.cached_all.map do |genre|
      { id: genre.tmdb_id, name: genre.name }
    end
    render json: { success: true, genres: genres }
  end

  def countries
    countries = Rails.cache.fetch('countries/all', expires_in: 24.hours) do
      ProductionCountry.order(:name).pluck(:iso_3166_1, :name).map do |code, name|
        { code: code, name: name }
      end
    end
    render json: { success: true, countries: countries }
  end

  def languages
    # Cache improved languages list
    languages = Rails.cache.fetch('languages/all_improved', expires_in: 24.hours) do
      # Filter out languages with "Unknown" names and improve language names
      OriginalLanguage.where.not(name: 'Unknown')
                      .order(:name)
                      .pluck(:iso_639_1, :name)
                      .map do |code, name|
      # Improve language names for better display
      improved_name = case code
                     when 'en'
                       'English'
                     when 'es'
                       'Spanish'
                     when 'fr'
                       'French'
                     when 'de'
                       'German'
                     when 'it'
                       'Italian'
                     when 'pt'
                       'Portuguese'
                     when 'ru'
                       'Russian'
                     when 'ja'
                       'Japanese'
                     when 'ko'
                       'Korean'
                     when 'zh'
                       'Chinese'
                     when 'ar'
                       'Arabic'
                     when 'hi'
                       'Hindi'
                     when 'nl'
                       'Dutch'
                     when 'sv'
                       'Swedish'
                     when 'da'
                       'Danish'
                     when 'no'
                       'Norwegian'
                     when 'fi'
                       'Finnish'
                     when 'pl'
                       'Polish'
                     when 'cs'
                       'Czech'
                     when 'hu'
                       'Hungarian'
                     when 'ro'
                       'Romanian'
                     when 'bg'
                       'Bulgarian'
                     when 'hr'
                       'Croatian'
                     when 'sk'
                       'Slovak'
                     when 'sl'
                       'Slovenian'
                     when 'et'
                       'Estonian'
                     when 'lv'
                       'Latvian'
                     when 'lt'
                       'Lithuanian'
                     when 'el'
                       'Greek'
                     when 'tr'
                       'Turkish'
                     when 'he'
                       'Hebrew'
                     when 'th'
                       'Thai'
                     when 'vi'
                       'Vietnamese'
                     when 'id'
                       'Indonesian'
                     when 'ms'
                       'Malay'
                     when 'tl'
                       'Filipino'
                     when 'uk'
                       'Ukrainian'
                     when 'be'
                       'Belarusian'
                     when 'ka'
                       'Georgian'
                     when 'hy'
                       'Armenian'
                     when 'az'
                       'Azerbaijani'
                     when 'kk'
                       'Kazakh'
                     when 'ky'
                       'Kyrgyz'
                     when 'uz'
                       'Uzbek'
                     when 'tg'
                       'Tajik'
                     when 'mn'
                       'Mongolian'
                     when 'bn'
                       'Bengali'
                     when 'ta'
                       'Tamil'
                     when 'te'
                       'Telugu'
                     when 'ml'
                       'Malayalam'
                     when 'kn'
                       'Kannada'
                     when 'gu'
                       'Gujarati'
                     when 'pa'
                       'Punjabi'
                     when 'or'
                       'Odia'
                     when 'as'
                       'Assamese'
                     when 'ne'
                       'Nepali'
                     when 'si'
                       'Sinhala'
                     when 'my'
                       'Burmese'
                     when 'km'
                       'Khmer'
                     when 'lo'
                       'Lao'
                     when 'ka'
                       'Georgian'
                     else
                       name # Use original name if no improvement available
                     end
      
        { code: code, name: improved_name }
      end
    end
    
    render json: { success: true, languages: languages }
  end

  private

  def set_search_service
    # Use current_user from session, fallback to first user for demo
    user = current_user || User.first
    @search_service = MovieSearchService.new(user)
  end
  
  # current_user is now defined in ApplicationController
end
