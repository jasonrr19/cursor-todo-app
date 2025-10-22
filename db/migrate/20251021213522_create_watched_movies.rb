class CreateWatchedMovies < ActiveRecord::Migration[7.1]
  def change
    create_table :watched_movies do |t|
      t.references :user, null: false, foreign_key: true
      t.references :movie, null: false, foreign_key: true
      t.datetime :watched_at

      t.timestamps
    end

    add_index :watched_movies, [:user_id, :movie_id], unique: true
    add_index :watched_movies, :watched_at
  end
end
