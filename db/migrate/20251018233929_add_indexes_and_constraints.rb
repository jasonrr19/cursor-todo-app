class AddIndexesAndConstraints < ActiveRecord::Migration[7.1]
  def change
    # Users table indexes
    add_index :users, :display_name
    add_index :users, :theme_preference

    # Movies table indexes
    add_index :movies, :tmdb_id, unique: true
    add_index :movies, :title
    add_index :movies, :release_date
    add_index :movies, :vote_average
    add_index :movies, :vote_count
    # production_country_id and original_language_id already indexed by foreign key

    # Genres table indexes
    add_index :genres, :tmdb_id, unique: true
    add_index :genres, :name

    # People table indexes
    add_index :people, :tmdb_id, unique: true
    add_index :people, :name
    add_index :people, :known_for_department

    # Production Countries table indexes
    add_index :production_countries, :iso_3166_1, unique: true
    add_index :production_countries, :name

    # Original Languages table indexes
    add_index :original_languages, :iso_639_1, unique: true
    add_index :original_languages, :name

    # Movie Genres join table indexes
    add_index :movie_genres, [:movie_id, :genre_id], unique: true
    # movie_id and genre_id already indexed by foreign keys

    # Movie People join table indexes
    add_index :movie_people, [:movie_id, :person_id, :job], unique: true
    add_index :movie_people, :job
    # movie_id and person_id already indexed by foreign keys

    # Lists table indexes
    add_index :lists, :privacy_level
    add_index :lists, :name
    # user_id already indexed by foreign key

    # List Movies join table indexes
    add_index :list_movies, [:list_id, :movie_id], unique: true
    # list_id and movie_id already indexed by foreign keys

    # Reviews table indexes
    add_index :reviews, [:user_id, :movie_id], unique: true
    add_index :reviews, :rating
    add_index :reviews, :created_at
    # user_id and movie_id already indexed by foreign keys

    # User Preferences table indexes
    add_index :user_preferences, :serendipity_intensity
    # user_id already indexed by foreign key

    # Recommendation Events table indexes
    add_index :recommendation_events, :event_type
    add_index :recommendation_events, :created_at
    # user_id and movie_id already indexed by foreign keys

    # Search Queries table indexes
    add_index :search_queries, :query
    add_index :search_queries, :created_at
    add_index :search_queries, :results_count
    # user_id already indexed by foreign key
  end
end
