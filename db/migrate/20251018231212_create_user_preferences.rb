class CreateUserPreferences < ActiveRecord::Migration[7.1]
  def change
    create_table :user_preferences do |t|
      t.references :user, null: false, foreign_key: true
      t.json :preferred_genres, default: []
      t.json :preferred_decades, default: []
      t.json :preferred_countries, default: []
      t.json :preferred_languages, default: []
      t.json :preferred_people, default: []
      t.string :serendipity_intensity, default: 'medium'

      t.timestamps
    end
  end
end
