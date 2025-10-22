class CreateOriginalLanguages < ActiveRecord::Migration[7.1]
  def change
    create_table :original_languages do |t|
      t.string :name
      t.string :iso_639_1

      t.timestamps
    end
  end
end
