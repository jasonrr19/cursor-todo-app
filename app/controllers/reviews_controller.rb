# frozen_string_literal: true

class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  before_action :set_movie, only: [:new, :create]

  def index
    @user = current_user
    @reviews = @user&.reviews&.includes(:movie)&.order(created_at: :desc) || []
    render layout: 'minimal'
  end

  def show
    render layout: 'minimal'
  end

  def new
    # Check if user has watched the movie
    unless current_user.watched?(@movie)
      redirect_to root_path, alert: 'You can only review movies you have watched. Please mark the movie as watched first.'
      return
    end

    # Check if user already has a review for this movie
    existing_review = current_user.reviews.find_by(movie: @movie)
    if existing_review
      redirect_to edit_review_path(existing_review), notice: 'You already have a review for this movie. You can edit it instead.'
      return
    end

    @review = @movie.reviews.build(user: current_user)
    render layout: 'minimal'
  end

  def create
    # Check if user has watched the movie
    unless current_user.watched?(@movie)
      redirect_to root_path, alert: 'You can only review movies you have watched.'
      return
    end

    # Check if user already has a review for this movie
    existing_review = current_user.reviews.find_by(movie: @movie)
    if existing_review
      redirect_to edit_review_path(existing_review), alert: 'You already have a review for this movie.'
      return
    end

    @review = @movie.reviews.build(review_params)
    @review.user = current_user

    if @review.save
      redirect_to my_reviews_path, notice: 'Review was successfully created.'
    else
      render :new, status: :unprocessable_entity, layout: 'minimal'
    end
  end

  def edit
    render layout: 'minimal'
  end

  def update
    if @review.update(review_params)
      @review.touch(:updated_at) # Ensure updated_at is changed
      redirect_to my_reviews_path, notice: 'Review was successfully updated.'
    else
      render :edit, status: :unprocessable_entity, layout: 'minimal'
    end
  end

  def destroy
    @review.destroy
    redirect_to my_reviews_path, notice: 'Review was successfully deleted.'
  end

  private

  def set_review
    @review = current_user.reviews.find(params[:id])
  end

  def set_movie
    @movie = Movie.find(params[:movie_id])
  end

  def review_params
    params.require(:review).permit(:rating, :review_text, :title, :contains_spoilers)
  end

  # current_user is now defined in ApplicationController
end


