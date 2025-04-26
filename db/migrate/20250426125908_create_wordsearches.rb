class CreateWordsearches < ActiveRecord::Migration[8.0]
  def change
    create_table :wordsearches do |t|
      t.json :grid
      t.references :week, null: false, foreign_key: true

      t.timestamps
    end
  end
end
