class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :display_name
      t.string :theme_preference

      t.timestamps
    end
  end
end
