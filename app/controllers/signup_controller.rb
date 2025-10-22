# frozen_string_literal: true

class SignupController < ApplicationController
  def new
    @user = User.new
    render layout: 'minimal'
  end

  def create
    @user = User.new(user_params)
    @user.theme_preference = 'system' # Set default theme preference
    
    if @user.save
      # Set the current user in session
      session[:user_id] = @user.id
      # Redirect to onboarding preferences
      redirect_to onboarding_path, notice: 'Welcome! Let\'s set up your preferences.'
    else
      render :new, status: :unprocessable_entity, layout: 'minimal'
    end
  end

  private

  def user_params
    params.require(:user).permit(:display_name)
  end
end
