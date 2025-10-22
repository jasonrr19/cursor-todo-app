// frozen_string_literal: true

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "query", "filters", "results", "container", "toggle"]

  connect() {
    this.loadFilterOptions()
  }

  async loadFilterOptions() {
    try {
      // Load genres
      const genresResponse = await fetch('/movies/genres')
      const genresData = await genresResponse.json()
      if (genresData.success) {
        this.populateSelect('filter-genre', genresData.genres)
      }

      // Load countries
      const countriesResponse = await fetch('/movies/countries')
      const countriesData = await countriesResponse.json()
      if (countriesData.success) {
        this.populateSelect('filter-language', countriesData.countries)
      }

      // Load languages
      const languagesResponse = await fetch('/movies/languages')
      const languagesData = await languagesResponse.json()
      if (languagesData.success) {
        this.populateSelect('filter-language', languagesData.languages)
      }

      // Add year options (last 50 years)
      this.populateYearOptions()
    } catch (error) {
      console.error('Failed to load filter options:', error)
    }
  }

  populateSelect(selectId, options) {
    const select = document.getElementById(selectId)
    if (!select) return

    // Clear existing options except the first one
    while (select.children.length > 1) {
      select.removeChild(select.lastChild)
    }

    options.forEach(option => {
      const optionElement = document.createElement('option')
      optionElement.value = option.id || option.code
      optionElement.textContent = option.name
      select.appendChild(optionElement)
    })
  }

  populateYearOptions() {
    const yearSelect = document.getElementById('filter-year')
    if (!yearSelect) return

    const currentYear = new Date().getFullYear()
    for (let year = currentYear; year >= currentYear - 50; year--) {
      const option = document.createElement('option')
      option.value = year
      option.textContent = year
      yearSelect.appendChild(option)
    }
  }

  toggleFilters() {
    const filters = this.filtersTarget
    const toggle = this.toggleTarget
    
    if (filters.style.display === 'none') {
      filters.style.display = 'block'
      toggle.textContent = 'Hide Filters'
    } else {
      filters.style.display = 'none'
      toggle.textContent = 'Advanced Filters'
    }
  }

  async search(event) {
    event.preventDefault()
    
    const query = this.queryTarget.value.trim()
    if (!query) return

    this.showLoading()

    try {
      const filters = this.getFilters()
      const response = await fetch(`/movies/search?q=${encodeURIComponent(query)}&${this.buildQueryString(filters)}`)
      const data = await response.json()

      if (data.success) {
        this.displayResults(data.results)
      } else {
        this.showError(data.error || 'Search failed')
      }
    } catch (error) {
      console.error('Search error:', error)
      this.showError('Search failed. Please try again.')
    }
  }

  getFilters() {
    return {
      genre: document.getElementById('filter-genre')?.value || '',
      year: document.getElementById('filter-year')?.value || '',
      language: document.getElementById('filter-language')?.value || '',
      country: document.getElementById('filter-country')?.value || ''
    }
  }

  buildQueryString(filters) {
    return Object.entries(filters)
      .filter(([_, value]) => value)
      .map(([key, value]) => `${key}=${encodeURIComponent(value)}`)
      .join('&')
  }

  displayResults(results) {
    const container = this.containerTarget
    container.innerHTML = ''

    if (results.length === 0) {
      container.innerHTML = '<p class="no-results">No movies found. Try a different search term.</p>'
      this.resultsTarget.style.display = 'block'
      return
    }

    results.forEach(movie => {
      const movieCard = this.createMovieCard(movie)
      container.appendChild(movieCard)
    })

    this.resultsTarget.style.display = 'block'
  }

  createMovieCard(movie) {
    const card = document.createElement('div')
    card.className = 'movie-card'
    
    const posterUrl = movie.poster_path 
      ? `https://image.tmdb.org/t/p/w300${movie.poster_path}`
      : '/assets/no-poster.png'

    card.innerHTML = `
      <div class="movie-poster">
        <img src="${posterUrl}" alt="${movie.title}" loading="lazy">
      </div>
      <div class="movie-info">
        <h3 class="movie-title">${movie.title}</h3>
        <p class="movie-year">${movie.release_date ? new Date(movie.release_date).getFullYear() : 'N/A'}</p>
        <p class="movie-rating">⭐ ${movie.vote_average.toFixed(1)} (${movie.vote_count} votes)</p>
        <p class="movie-genres">${movie.genres.join(', ')}</p>
        <p class="movie-overview">${movie.overview ? movie.overview.substring(0, 150) + '...' : 'No overview available'}</p>
        <div class="movie-actions">
          <button class="btn btn--primary btn--small" data-action="click->movie-search#addToList" data-movie-id="${movie.tmdb_id}">
            Add to List
          </button>
          <button class="btn btn--ghost btn--small" data-action="click->movie-search#viewDetails" data-movie-id="${movie.tmdb_id}">
            Details
          </button>
        </div>
      </div>
    `

    return card
  }

  addToList(event) {
    const movieId = event.target.dataset.movieId
    // TODO: Implement add to list functionality
    console.log('Add to list:', movieId)
    alert('Add to list functionality coming soon!')
  }

  viewDetails(event) {
    const movieId = event.target.dataset.movieId
    // TODO: Implement view details functionality
    console.log('View details:', movieId)
    alert('View details functionality coming soon!')
  }

  showLoading() {
    const container = this.containerTarget
    container.innerHTML = '<div class="loading">Searching movies...</div>'
    this.resultsTarget.style.display = 'block'
  }

  showError(message) {
    const container = this.containerTarget
    container.innerHTML = `<div class="error">${message}</div>`
    this.resultsTarget.style.display = 'block'
  }
}





