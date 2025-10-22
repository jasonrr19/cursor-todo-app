# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Basic application controller setup
  
  # Simple session-based user tracking (demo-only, not production-grade)
  helper_method :current_user, :logged_in?
  
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
  
  def logged_in?
    current_user.present?
  end
  
  # Error handling
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found if Rails.env.production?
  
  private
  
  def handle_not_found
    render template: 'errors/not_found', layout: 'minimal', status: :not_found
  end
end
