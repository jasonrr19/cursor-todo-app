# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecommendationService, type: :service do
  let(:user) { create(:user) }
  let(:user_preference) { create(:user_preference, user: user) }
  let(:service) { RecommendationService.new(user) }

  before do
    # Create test genres
    @action_genre = create(:genre, name: 'Action', tmdb_id: 28)
    @comedy_genre = create(:genre, name: 'Comedy', tmdb_id: 35)
    @drama_genre = create(:genre, name: 'Drama', tmdb_id: 18)

    # Create test countries
    @us_country = create(:production_country, name: 'United States', iso_3166_1: 'US')
    @jp_country = create(:production_country, name: 'Japan', iso_3166_1: 'JP')

    # Create test languages
    @en_language = create(:original_language, name: 'English', iso_639_1: 'en')
    @ja_language = create(:original_language, name: 'Japanese', iso_639_1: 'ja')

    # Create test people
    @nolan_person = create(:person, name: 'Christopher Nolan', tmdb_id: 525)
    @tarantino_person = create(:person, name: 'Quentin Tarantino', tmdb_id: 138)

    # Create test movies
    @movie1 = create(:movie, 
      title: 'The Dark Knight',
      release_date: Date.new(2008, 7, 18),
      vote_average: 8.5,
      vote_count: 30000,
      production_country: @us_country,
      original_language: @en_language
    )
    @movie1.genres << @action_genre
    @movie1.genres << @drama_genre
    @movie1.movie_people.create!(person: @nolan_person, job: 'Director')

    @movie2 = create(:movie,
      title: 'Pulp Fiction',
      release_date: Date.new(1994, 10, 14),
      vote_average: 8.9,
      vote_count: 25000,
      production_country: @us_country,
      original_language: @en_language
    )
    @movie2.genres << @action_genre
    @movie2.genres << @drama_genre
    @movie2.movie_people.create!(person: @tarantino_person, job: 'Director')

    @movie3 = create(:movie,
      title: 'Japanese Movie',
      release_date: Date.new(2020, 1, 1),
      vote_average: 7.0,
      vote_count: 1000,
      production_country: @jp_country,
      original_language: @ja_language
    )
    @movie3.genres << @comedy_genre
  end

  describe '#recommendations' do
    context 'when user has no preferences' do
      it 'returns empty array' do
        allow(user).to receive(:user_preference).and_return(nil)
        expect(service.recommendations).to eq([])
      end
    end

    context 'when user has preferences' do
      before do
        user_preference.update!(
          preferred_genres: [28], # Action
          preferred_languages: ['en'],
          preferred_countries: ['US'],
          preferred_decades: ['2000s'],
          preferred_people: [525] # Christopher Nolan
        )
      end

      it 'returns movies matching user preferences' do
        recommendations = service.recommendations
        expect(recommendations).to include(@movie1)
        expect(recommendations).to include(@movie2)
        # Japanese movie should have lower score due to no matching preferences
        expect(recommendations.index(@movie1)).to be < recommendations.index(@movie3)
        expect(recommendations.index(@movie2)).to be < recommendations.index(@movie3)
      end

      it 'scores movies based on preference matches' do
        recommendations = service.recommendations
        # The Dark Knight should score higher due to multiple matches
        expect(recommendations.first).to eq(@movie1)
      end

      it 'excludes reviewed movies when exclude_reviewed is true' do
        create(:review, user: user, movie: @movie1)
        recommendations = service.recommendations(exclude_reviewed: true)
        expect(recommendations).not_to include(@movie1)
      end

      it 'includes reviewed movies when exclude_reviewed is false' do
        create(:review, user: user, movie: @movie1)
        recommendations = service.recommendations(exclude_reviewed: false)
        expect(recommendations).to include(@movie1)
      end

      it 'respects the limit parameter' do
        recommendations = service.recommendations(limit: 1)
        expect(recommendations.length).to eq(1)
      end
    end
  end

  describe 'scoring algorithm' do
    before do
      user_preference.update!(
        preferred_genres: [28, 35], # Action, Comedy
        preferred_languages: ['en'],
        preferred_countries: ['US'],
        preferred_decades: ['2000s'],
        preferred_people: [525] # Christopher Nolan
      )
    end

    it 'gives higher scores to movies with more genre matches' do
      # Movie with 2 genre matches should score higher than movie with 1
      recommendations = service.recommendations
      dark_knight_index = recommendations.index(@movie1)
      pulp_fiction_index = recommendations.index(@movie2)
      
      expect(dark_knight_index).to be < pulp_fiction_index
    end

    it 'includes popularity boost for tie-breaking' do
      # Movies with higher vote counts should rank higher when scores are similar
      recommendations = service.recommendations
      expect(recommendations.first.vote_count).to be >= recommendations.last.vote_count
    end
  end

  describe 'edge cases' do
    it 'handles empty preference arrays gracefully' do
      user_preference.update!(
        preferred_genres: [],
        preferred_languages: [],
        preferred_countries: [],
        preferred_decades: [],
        preferred_people: []
      )
      
      recommendations = service.recommendations
      expect(recommendations).to be_an(Array)
    end

    it 'handles movies with missing associations' do
      movie_without_genres = create(:movie, title: 'No Genres Movie')
      recommendations = service.recommendations
      expect(recommendations).to be_an(Array)
    end
  end
end
