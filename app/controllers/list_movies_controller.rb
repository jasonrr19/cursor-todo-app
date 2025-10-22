# frozen_string_literal: true

class ListMoviesController < ApplicationController
  before_action :set_list
  before_action :set_movie, only: [:create, :destroy]

  def create
    # Check if movie is already in the list
    if @list.movies.include?(@movie)
      render json: { error: 'Movie is already in this list' }, status: :unprocessable_entity
      return
    end

    # Get the next position (highest position + 1)
    next_position = @list.list_movies.maximum(:position).to_i + 1

    # Create the list movie association
    list_movie = @list.list_movies.build(movie: @movie, position: next_position)
    
    if list_movie.save
      # Track the "accept" event - user accepted a recommendation by adding to list
      track_accept_event(params[:source])
      
      render json: { 
        success: true, 
        message: "#{@movie.title} added to #{@list.name}",
        list_id: @list.id,
        movie_id: @movie.id
      }
    else
      render json: { error: 'Failed to add movie to list' }, status: :unprocessable_entity
    end
  end

  def destroy
    list_movie = @list.list_movies.find_by(movie: @movie)
    
    if list_movie&.destroy
      render json: { 
        success: true, 
        message: "#{@movie.title} removed from #{@list.name}" 
      }
    else
      render json: { error: 'Movie not found in this list' }, status: :not_found
    end
  end

  def update_positions
    position_updates = params[:positions] || {}
    
    position_updates.each do |list_movie_id, position|
      list_movie = @list.list_movies.find(list_movie_id)
      list_movie.update(position: position.to_i)
    end

    render json: { success: true, message: 'List order updated' }
  end

  private

  def set_list
    @list = current_user.lists.find(params[:list_id])
  end

  def set_movie
    @movie = Movie.find(params[:movie_id])
  end

  # current_user is now defined in ApplicationController
  
  def track_accept_event(source = nil)
    return unless current_user && @movie
    
    RecommendationEvent.create(
      user: current_user,
      movie: @movie,
      event_type: 'accept',
      context: {
        source: source || 'list_add',
        list_id: @list&.id,
        list_name: @list&.name,
        timestamp: Time.current.to_i
      }
    )
  rescue => e
    Rails.logger.error "Failed to track accept event for movie #{@movie.id}: #{e.message}"
    # Don't fail the request if tracking fails
  end
end

