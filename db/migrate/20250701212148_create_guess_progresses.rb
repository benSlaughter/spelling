class CreateGuessProgresses < ActiveRecord::Migration[8.0]
  def change
    create_table :guess_progresses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :week, null: false, foreign_key: true
      t.text :guessed_words
      t.boolean :completed, default: false

      t.timestamps
    end
  end
end
