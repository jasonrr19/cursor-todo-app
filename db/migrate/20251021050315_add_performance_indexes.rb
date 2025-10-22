class AddPerformanceIndexes < ActiveRecord::Migration[7.1]
  def change
    # Add index on movies.popularity for serendipity queries
    add_index :movies, :popularity unless index_exists?(:movies, :popularity)
    
    # Add index on list_movies.position for ordering lists
    add_column :list_movies, :position, :integer, default: 0 unless column_exists?(:list_movies, :position)
    add_index :list_movies, :position unless index_exists?(:list_movies, :position)
    
    # Add composite index for efficient review lookups
    add_index :reviews, [:movie_id, :rating] unless index_exists?(:reviews, [:movie_id, :rating])
    
    # Add composite index for efficient recommendation event queries
    add_index :recommendation_events, [:user_id, :event_type, :created_at] unless index_exists?(:recommendation_events, [:user_id, :event_type, :created_at])
    
    # Add index on reviews.title for searching reviews
    add_column :reviews, :title, :string unless column_exists?(:reviews, :title)
    add_index :reviews, :title unless index_exists?(:reviews, :title)
    
    # Add index on reviews.contains_spoilers for filtering
    add_column :reviews, :contains_spoilers, :boolean, default: false unless column_exists?(:reviews, :contains_spoilers)
    add_index :reviews, :contains_spoilers unless index_exists?(:reviews, :contains_spoilers)
    
    # Add composite index for filtering movies by country and language
    add_index :movies, [:production_country_id, :original_language_id] unless index_exists?(:movies, [:production_country_id, :original_language_id])
    
    # Add composite index for vote-based queries (for serendipity)
    add_index :movies, [:vote_count, :vote_average] unless index_exists?(:movies, [:vote_count, :vote_average])
  end
end
