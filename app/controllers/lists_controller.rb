# frozen_string_literal: true

class ListsController < ApplicationController
  before_action :set_list, only: [:show, :edit, :update, :destroy]

  def index
    @user = current_user
    @lists = @user&.lists&.includes(:list_movies, :movies) || []
    
    respond_to do |format|
      format.html { render layout: 'minimal' }
      format.json { render json: @lists.as_json(include: { movies: { only: [:id, :title] } }, methods: [:movies_count]) }
    end
  end

  def show
    @movies = @list.movies.includes(:genres, :production_country, :original_language)
                   .order('list_movies.position ASC')
    render layout: 'minimal'
  end

  def new
    unless current_user
      redirect_to root_path, alert: 'Please sign in to create a list.'
      return
    end
    
    @list = List.new
    render layout: 'minimal'
  end

  def create
    @user = current_user
    
    unless @user
      redirect_to root_path, alert: 'Please sign in to create a list.'
      return
    end
    
    @list = @user.lists.build(list_params)
    
    # Check soft cap (100 lists per user)
    if @user.lists.count >= 100
      @list.errors.add(:base, 'You have reached the maximum number of lists (100)')
      render :new, status: :unprocessable_entity, layout: 'minimal'
      return
    end

    if @list.save
      redirect_to @list, notice: 'List was successfully created.'
    else
      render :new, status: :unprocessable_entity, layout: 'minimal'
    end
  end

  def edit
    render layout: 'minimal'
  end

  def update
    if @list.update(list_params)
      redirect_to @list, notice: 'List was successfully updated.'
    else
      render :edit, status: :unprocessable_entity, layout: 'minimal'
    end
  end

  def destroy
    @list.destroy
    redirect_to lists_url, notice: 'List was successfully deleted.'
  end

  private

  def set_list
    @list = current_user.lists.find(params[:id])
  end

  def list_params
    params.require(:list).permit(:name, :description, :privacy_level)
  end

  # current_user is now defined in ApplicationController
end
