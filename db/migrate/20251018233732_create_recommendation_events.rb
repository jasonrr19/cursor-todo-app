class CreateRecommendationEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :recommendation_events do |t|
      t.references :user, null: false, foreign_key: true
      t.references :movie, null: false, foreign_key: true
      t.string :event_type
      t.json :context

      t.timestamps
    end
  end
end
