class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.integer :rating
      t.text :review_text
      t.references :user, null: false, foreign_key: true
      t.references :movie, null: false, foreign_key: true
      t.datetime :edited_at
      t.integer :edit_count

      t.timestamps
    end
  end
end
