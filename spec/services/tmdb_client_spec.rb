# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TmdbClient, type: :service do
  let(:client) { described_class.new }
  let(:api_key) { 'test_api_key' }
  let(:base_url) { 'https://api.themoviedb.org/3' }

  before do
    allow(Rails.application.config).to receive(:tmdb).and_return({
      api_key: api_key,
      base_url: base_url,
      timeout: 10,
      retries: 3
    })
  end

  describe '#fetch_genres' do
    it 'fetches genres from TMDB API' do
      stub_request(:get, "#{base_url}/genre/movie/list")
        .with(query: { api_key: api_key, language: 'en-US' })
        .to_return(status: 200, body: { genres: [{ id: 28, name: 'Action' }] }.to_json)

      result = client.fetch_genres

      expect(result).to eq({ 'genres' => [{ 'id' => 28, 'name' => 'Action' }] })
    end
  end

  describe '#fetch_movie_details' do
    it 'fetches movie details by TMDB ID' do
      tmdb_id = 123
      stub_request(:get, "#{base_url}/movie/#{tmdb_id}")
        .with(query: { api_key: api_key, language: 'en-US' })
        .to_return(status: 200, body: { id: tmdb_id, title: 'Test Movie' }.to_json)

      result = client.fetch_movie_details(tmdb_id)

      expect(result).to eq({ 'id' => tmdb_id, 'title' => 'Test Movie' })
    end
  end

  describe '#search_movies' do
    it 'searches movies with query' do
      query = 'Inception'
      stub_request(:get, "#{base_url}/search/movie")
        .with(query: { api_key: api_key, language: 'en-US', query: query, page: 1, include_adult: false })
        .to_return(status: 200, body: { results: [{ id: 1, title: 'Inception' }] }.to_json)

      result = client.search_movies(query)

      expect(result).to eq({ 'results' => [{ 'id' => 1, 'title' => 'Inception' }] })
    end

    it 'searches movies with additional parameters' do
      query = 'Action'
      year = 2020
      genre = 28

      stub_request(:get, "#{base_url}/search/movie")
        .with(query: { 
          api_key: api_key, 
          language: 'en-US', 
          query: query, 
          page: 2, 
          include_adult: false,
          year: year,
          with_genres: genre
        })
        .to_return(status: 200, body: { results: [] }.to_json)

      result = client.search_movies(query, page: 2, year: year, genre: genre)

      expect(result).to eq({ 'results' => [] })
    end
  end

  describe '#search_people' do
    it 'searches people with query' do
      query = 'Christopher Nolan'
      stub_request(:get, "#{base_url}/search/person")
        .with(query: { api_key: api_key, language: 'en-US', query: query, page: 1, include_adult: false })
        .to_return(status: 200, body: { results: [{ id: 1, name: 'Christopher Nolan' }] }.to_json)

      result = client.search_people(query)

      expect(result).to eq({ 'results' => [{ 'id' => 1, 'name' => 'Christopher Nolan' }] })
    end
  end

  describe '#fetch_credits' do
    it 'fetches movie credits by TMDB ID' do
      tmdb_id = 123
      stub_request(:get, "#{base_url}/movie/#{tmdb_id}/credits")
        .with(query: { api_key: api_key, language: 'en-US' })
        .to_return(status: 200, body: { cast: [], crew: [] }.to_json)

      result = client.fetch_credits(tmdb_id)

      expect(result).to eq({ 'cast' => [], 'crew' => [] })
    end
  end

  describe 'error handling' do
    it 'raises TmdbClientError for 401 unauthorized' do
      stub_request(:get, "#{base_url}/genre/movie/list")
        .with(query: { api_key: api_key, language: 'en-US' })
        .to_return(status: 401)

      expect { client.fetch_genres }.to raise_error(TmdbClientError, 'Invalid API key')
    end

    it 'raises TmdbClientError for 404 not found' do
      stub_request(:get, "#{base_url}/movie/999999")
        .with(query: { api_key: api_key, language: 'en-US' })
        .to_return(status: 404)

      expect { client.fetch_movie_details(999999) }.to raise_error(TmdbClientError, 'Resource not found')
    end

    it 'raises TmdbClientError for 429 rate limit' do
      stub_request(:get, "#{base_url}/genre/movie/list")
        .with(query: { api_key: api_key, language: 'en-US' })
        .to_return(status: 429)

      expect { client.fetch_genres }.to raise_error(TmdbClientError, 'Rate limit exceeded')
    end

    it 'retries on timeout with exponential backoff' do
      stub_request(:get, "#{base_url}/genre/movie/list")
        .with(query: { api_key: api_key, language: 'en-US' })
        .to_timeout

      expect { client.fetch_genres }.to raise_error(TmdbClientError)
    end
  end
end
