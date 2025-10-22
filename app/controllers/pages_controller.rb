class PagesController < ApplicationController
  def home
    render layout: 'minimal'
  end
end
