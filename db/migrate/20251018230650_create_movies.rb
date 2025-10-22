class CreateMovies < ActiveRecord::Migration[7.1]
  def change
    create_table :movies do |t|
      t.string :title
      t.integer :tmdb_id
      t.text :overview
      t.date :release_date
      t.decimal :vote_average
      t.integer :vote_count
      t.string :poster_path
      t.string :backdrop_path
      t.integer :runtime
      t.references :production_country, null: false, foreign_key: { to_table: :production_countries }
      t.references :original_language, null: false, foreign_key: { to_table: :original_languages }

      t.timestamps
    end
  end
end
