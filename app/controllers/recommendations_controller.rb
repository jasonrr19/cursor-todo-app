# frozen_string_literal: true

class RecommendationsController < ApplicationController
  def index
    @user = current_user
    @recommendations = []
    @serendipity_suggestions = []
    @fallback_mode = false
    
    if @user&.user_preference
      service = RecommendationService.new(@user)
      @recommendations, @fallback_mode = service.recommendations_with_fallback_info(limit: 20)
      @serendipity_suggestions = service.serendipity_suggestions(limit: 5)
      
      # Track impressions for regular recommendations
      track_impressions(@recommendations, 'recommendations_index')
      
      # Track impressions for serendipity suggestions
      track_impressions(@serendipity_suggestions, 'serendipity_widget', serendipity_mode: 'mixed')
    end
    
    render layout: 'minimal'
  end

  def serendipity
    @user = current_user
    @mode = params[:mode] || 'low'
    @movies = []
    
    if @user&.user_preference && %w[low obscure].include?(@mode)
      service = RecommendationService.new(@user)
      @movies = service.recommendations(limit: 20, serendipity_mode: @mode)
      
      # Track impressions for serendipity page
      track_impressions(@movies, 'serendipity_page', serendipity_mode: @mode)
    end
    
    render layout: 'minimal'
  end
  
  def track_event
    @user = current_user
    return render json: { success: false, error: 'Not authenticated' }, status: :unauthorized unless @user
    
    movie = Movie.find_by(id: params[:movie_id])
    return render json: { success: false, error: 'Movie not found' }, status: :not_found unless movie
    
    event_type = params[:event_type]
    unless %w[impression accept dismiss].include?(event_type)
      return render json: { success: false, error: 'Invalid event type' }, status: :unprocessable_entity
    end
    
    context = {
      source: params[:source] || 'unknown',
      serendipity_mode: params[:serendipity_mode],
      position: params[:position]&.to_i,
      timestamp: Time.current.to_i
    }.compact
    
    RecommendationEvent.create!(
      user: @user,
      movie: movie,
      event_type: event_type,
      context: context
    )
    
    render json: { success: true }
  rescue => e
    Rails.logger.error "Failed to track recommendation event: #{e.message}"
    render json: { success: false, error: 'Failed to track event' }, status: :internal_server_error
  end

  private

  # current_user is now defined in ApplicationController
  
  def track_impressions(movies, source, **additional_context)
    return if movies.blank? || @user.blank?
    
    movies.each_with_index do |movie, index|
      RecommendationEvent.create(
        user: @user,
        movie: movie,
        event_type: 'impression',
        context: {
          source: source,
          position: index,
          timestamp: Time.current.to_i,
          **additional_context
        }
      )
    rescue => e
      Rails.logger.error "Failed to track impression for movie #{movie.id}: #{e.message}"
      # Don't fail the request if tracking fails
    end
  end
end
