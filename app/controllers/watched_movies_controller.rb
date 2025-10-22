class WatchedMoviesController < ApplicationController
  before_action :set_user
  before_action :set_movie, only: [:create, :destroy]

  # POST /watched_movies
  def create
    watched_movie = @user.mark_as_watched(@movie)
    
    if watched_movie.persisted?
      render json: { 
        success: true, 
        message: 'Movie marked as watched',
        watched: true
      }
    else
      render json: { 
        success: false, 
        error: 'Failed to mark movie as watched'
      }, status: :unprocessable_entity
    end
  end

  # DELETE /watched_movies/:movie_id
  def destroy
    @user.unmark_as_watched(@movie)
    
    render json: { 
      success: true, 
      message: 'Movie unmarked as watched',
      watched: false
    }
  end

  # GET /watched_movies
  def index
    @watched_movies = @user.watched_movies
                           .includes(movie: [:genres, :production_country, :original_language])
                           .order(watched_at: :desc)
    
    render layout: 'minimal'
  end

  # GET /watched_movies/check/:movie_id
  def check
    movie = Movie.find_by(id: params[:movie_id])
    
    if movie
      watched = @user.watched?(movie)
      render json: { success: true, watched: watched }
    else
      render json: { success: false, error: 'Movie not found' }, status: :not_found
    end
  end

  private

  def set_user
    @user = current_user || User.first || User.create!(display_name: 'Demo User', theme_preference: 'system')
  end

  def set_movie
    @movie = Movie.find_by(id: params[:movie_id])
    
    unless @movie
      render json: { 
        success: false, 
        error: 'Movie not found' 
      }, status: :not_found
    end
  end
end

