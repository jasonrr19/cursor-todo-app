# frozen_string_literal: true

class ProfileController < ApplicationController
  def show
    @user = current_user
    @reviews_count = @user&.reviews&.count || 0
    @lists_count = @user&.lists&.count || 0
    
    render layout: 'minimal'
  end

  private

  # current_user is now defined in ApplicationController
end


