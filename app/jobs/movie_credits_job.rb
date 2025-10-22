# frozen_string_literal: true

class MovieCreditsJob < ApplicationJob
  queue_as :default

  def perform(movie_id)
    movie = Movie.find(movie_id)
    return unless movie

    Rails.logger.info "Fetching credits for movie: #{movie.title} (ID: #{movie.id})"

    begin
      tmdb_client = TmdbClient.new
      credits = tmdb_client.fetch_credits(movie.tmdb_id)

      # Process crew members (directors, writers, etc.)
      if credits['crew']
        credits['crew'].each do |person_data|
          next unless person_data['job']&.in?(%w[Director Writer Producer Cinematographer Editor Composer])

          person = Person.find_or_create_by(tmdb_id: person_data['id']) do |p|
            p.name = person_data['name']
            p.known_for_department = person_data['known_for_department']
            p.profile_path = person_data['profile_path']
          end

          # Update person if they already exist but have new info
          if person.persisted? && person.name != person_data['name']
            person.update!(
              name: person_data['name'],
              known_for_department: person_data['known_for_department'],
              profile_path: person_data['profile_path']
            )
          end

          MoviePerson.find_or_create_by(
            movie: movie,
            person: person,
            job: person_data['job']
          )
        end
      end

      # Process cast members (actors)
      if credits['cast']
        credits['cast'].first(20).each do |person_data| # Limit to top 20 cast
          person = Person.find_or_create_by(tmdb_id: person_data['id']) do |p|
            p.name = person_data['name']
            p.known_for_department = person_data['known_for_department'] || 'Acting'
            p.profile_path = person_data['profile_path']
          end

          # Update person if they already exist but have new info
          if person.persisted? && person.name != person_data['name']
            person.update!(
              name: person_data['name'],
              known_for_department: person_data['known_for_department'] || 'Acting',
              profile_path: person_data['profile_path']
            )
          end

          MoviePerson.find_or_create_by(
            movie: movie,
            person: person,
            job: 'Actor'
          )
        end
      end

      Rails.logger.info "Successfully processed credits for: #{movie.title}"
    rescue TmdbClientError => e
      Rails.logger.error "Failed to fetch credits for #{movie.title}: #{e.message}"
      raise e
    rescue => e
      Rails.logger.error "Unexpected error processing credits for #{movie.title}: #{e.message}"
      raise e
    end
  end
end





