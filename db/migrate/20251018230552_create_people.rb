class CreatePeople < ActiveRecord::Migration[7.1]
  def change
    create_table :people do |t|
      t.string :name
      t.integer :tmdb_id
      t.string :known_for_department
      t.string :profile_path

      t.timestamps
    end
  end
end
