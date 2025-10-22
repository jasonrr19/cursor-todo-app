class MakeSearchQueriesUserIdOptional < ActiveRecord::Migration[7.1]
  def change
    change_column_null :search_queries, :user_id, true
  end
end
