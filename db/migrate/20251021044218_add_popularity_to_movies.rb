class AddPopularityToMovies < ActiveRecord::Migration[7.1]
  def change
    add_column :movies, :popularity, :decimal
  end
end
