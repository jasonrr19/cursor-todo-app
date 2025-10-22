# frozen_string_literal: true

class SessionsController < ApplicationController
  def destroy
    # Clear the user session
    session[:user_id] = nil
    redirect_to root_path, notice: 'You have been signed out successfully.'
  end
end

