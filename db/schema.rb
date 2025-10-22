# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_10_21_044218) do
  create_table "genres", force: :cascade do |t|
    t.string "name"
    t.integer "tmdb_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_genres_on_name"
    t.index ["tmdb_id"], name: "index_genres_on_tmdb_id", unique: true
  end

  create_table "list_movies", force: :cascade do |t|
    t.integer "list_id", null: false
    t.integer "movie_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["list_id", "movie_id"], name: "index_list_movies_on_list_id_and_movie_id", unique: true
    t.index ["list_id"], name: "index_list_movies_on_list_id"
    t.index ["movie_id"], name: "index_list_movies_on_movie_id"
  end

  create_table "lists", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "privacy_level"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_lists_on_name"
    t.index ["privacy_level"], name: "index_lists_on_privacy_level"
    t.index ["user_id"], name: "index_lists_on_user_id"
  end

  create_table "movie_genres", force: :cascade do |t|
    t.integer "movie_id", null: false
    t.integer "genre_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["genre_id"], name: "index_movie_genres_on_genre_id"
    t.index ["movie_id", "genre_id"], name: "index_movie_genres_on_movie_id_and_genre_id", unique: true
    t.index ["movie_id"], name: "index_movie_genres_on_movie_id"
  end

  create_table "movie_people", force: :cascade do |t|
    t.integer "movie_id", null: false
    t.integer "person_id", null: false
    t.string "job"
    t.string "character"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job"], name: "index_movie_people_on_job"
    t.index ["movie_id", "person_id", "job"], name: "index_movie_people_on_movie_id_and_person_id_and_job", unique: true
    t.index ["movie_id"], name: "index_movie_people_on_movie_id"
    t.index ["person_id"], name: "index_movie_people_on_person_id"
  end

  create_table "movies", force: :cascade do |t|
    t.string "title"
    t.integer "tmdb_id"
    t.text "overview"
    t.date "release_date"
    t.decimal "vote_average"
    t.integer "vote_count"
    t.string "poster_path"
    t.string "backdrop_path"
    t.integer "runtime"
    t.integer "production_country_id", null: false
    t.integer "original_language_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "popularity"
    t.index ["original_language_id"], name: "index_movies_on_original_language_id"
    t.index ["production_country_id"], name: "index_movies_on_production_country_id"
    t.index ["release_date"], name: "index_movies_on_release_date"
    t.index ["title"], name: "index_movies_on_title"
    t.index ["tmdb_id"], name: "index_movies_on_tmdb_id", unique: true
    t.index ["vote_average"], name: "index_movies_on_vote_average"
    t.index ["vote_count"], name: "index_movies_on_vote_count"
  end

  create_table "original_languages", force: :cascade do |t|
    t.string "name"
    t.string "iso_639_1"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["iso_639_1"], name: "index_original_languages_on_iso_639_1", unique: true
    t.index ["name"], name: "index_original_languages_on_name"
  end

  create_table "people", force: :cascade do |t|
    t.string "name"
    t.integer "tmdb_id"
    t.string "known_for_department"
    t.string "profile_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["known_for_department"], name: "index_people_on_known_for_department"
    t.index ["name"], name: "index_people_on_name"
    t.index ["tmdb_id"], name: "index_people_on_tmdb_id", unique: true
  end

  create_table "production_countries", force: :cascade do |t|
    t.string "name"
    t.string "iso_3166_1"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["iso_3166_1"], name: "index_production_countries_on_iso_3166_1", unique: true
    t.index ["name"], name: "index_production_countries_on_name"
  end

  create_table "recommendation_events", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "movie_id", null: false
    t.string "event_type"
    t.json "context"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_recommendation_events_on_created_at"
    t.index ["event_type"], name: "index_recommendation_events_on_event_type"
    t.index ["movie_id"], name: "index_recommendation_events_on_movie_id"
    t.index ["user_id"], name: "index_recommendation_events_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "rating"
    t.text "review_text"
    t.integer "user_id", null: false
    t.integer "movie_id", null: false
    t.datetime "edited_at"
    t.integer "edit_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_reviews_on_created_at"
    t.index ["movie_id"], name: "index_reviews_on_movie_id"
    t.index ["rating"], name: "index_reviews_on_rating"
    t.index ["user_id", "movie_id"], name: "index_reviews_on_user_id_and_movie_id", unique: true
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "search_queries", force: :cascade do |t|
    t.integer "user_id"
    t.string "query"
    t.json "filters"
    t.integer "results_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_search_queries_on_created_at"
    t.index ["query"], name: "index_search_queries_on_query"
    t.index ["results_count"], name: "index_search_queries_on_results_count"
    t.index ["user_id"], name: "index_search_queries_on_user_id"
  end

  create_table "todos", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.boolean "completed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_todos_on_user_id"
  end

  create_table "user_preferences", force: :cascade do |t|
    t.integer "user_id", null: false
    t.json "preferred_genres", default: []
    t.json "preferred_decades", default: []
    t.json "preferred_countries", default: []
    t.json "preferred_languages", default: []
    t.json "preferred_people", default: []
    t.string "serendipity_intensity", default: "medium"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["serendipity_intensity"], name: "index_user_preferences_on_serendipity_intensity"
    t.index ["user_id"], name: "index_user_preferences_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "display_name"
    t.string "theme_preference"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["display_name"], name: "index_users_on_display_name"
    t.index ["theme_preference"], name: "index_users_on_theme_preference"
  end

  add_foreign_key "list_movies", "lists"
  add_foreign_key "list_movies", "movies"
  add_foreign_key "lists", "users"
  add_foreign_key "movie_genres", "genres"
  add_foreign_key "movie_genres", "movies"
  add_foreign_key "movie_people", "movies"
  add_foreign_key "movie_people", "people"
  add_foreign_key "movies", "original_languages"
  add_foreign_key "movies", "production_countries"
  add_foreign_key "recommendation_events", "movies"
  add_foreign_key "recommendation_events", "users"
  add_foreign_key "reviews", "movies"
  add_foreign_key "reviews", "users"
  add_foreign_key "search_queries", "users"
  add_foreign_key "todos", "users"
  add_foreign_key "user_preferences", "users"
end
