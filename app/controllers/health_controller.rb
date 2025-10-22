# frozen_string_literal: true

class HealthController < ApplicationController
  def index
    health_status = {
      status: 'ok',
      timestamp: Time.current.iso8601,
      version: Rails.application.config.app_name,
      environment: Rails.env,
      database: database_status,
      uptime: uptime_seconds
    }

    render json: health_status, status: :ok
  end

  private

  def database_status
    ActiveRecord::Base.connection.execute('SELECT 1')
    'connected'
  rescue StandardError
    'disconnected'
  end

  def uptime_seconds
    Process.clock_gettime(Process::CLOCK_MONOTONIC).to_i
  end
end
