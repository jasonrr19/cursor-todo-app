# frozen_string_literal: true

Rails.application.routes.draw do
  get 'onboarding/show'
  get 'onboarding/update'
  get 'signup/new'
  get 'signup/create'
  get 'pages/home'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Health check endpoint
  get 'up' => 'health#index', as: :health_check

  # Defines the root path route ("/")
  root 'pages#home'

  # Todo routes
  resources :todos do
    member do
      patch :toggle
    end
  end

  # Signup routes
  get 'signup', to: 'signup#new'
  post 'signup', to: 'signup#create'
  
  # Session routes
  delete 'signout', to: 'sessions#destroy'

  # Onboarding routes
  get 'onboarding', to: 'onboarding#show'
  patch 'onboarding', to: 'onboarding#update'

  # Movie routes
  get 'movies/search', to: 'movies#search'
  get 'movies/search_people', to: 'movies#search_people'
  get 'movies/genres', to: 'movies#genres'
  get 'movies/countries', to: 'movies#countries'
  get 'movies/languages', to: 'movies#languages'
  get 'movies/:id', to: 'movies#show'

  # Recommendations routes
  get 'recommendations', to: 'recommendations#index'
  get 'recommendations/serendipity', to: 'recommendations#serendipity'
  post 'recommendations/track_event', to: 'recommendations#track_event'

  # Lists routes
  resources :lists do
    resources :list_movies, only: [:create, :destroy]
    patch 'list_movies/update_positions', to: 'list_movies#update_positions'
  end

  # Reviews routes
  resources :reviews, except: [:index]
  get 'my-reviews', to: 'reviews#index'
  
  # Movie reviews (nested)
  resources :movies do
    resources :reviews, only: [:new, :create]
  end

  # Profile route
  get 'profile', to: 'profile#show'

  # Watched movies routes
  resources :watched_movies, only: [:index, :create]
  delete 'watched_movies/:movie_id', to: 'watched_movies#destroy'
  get 'watched_movies/check/:movie_id', to: 'watched_movies#check'

  # Error pages
  match '/404', to: 'errors#not_found', via: :all
  match '/422', to: 'errors#unprocessable_entity', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
end
