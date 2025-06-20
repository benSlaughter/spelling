class CreateWordsearchProgresses < ActiveRecord::Migration[8.0]
  def change
    create_table :wordsearch_progresses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :wordsearch, null: false, foreign_key: true
      t.text :found_words

      t.timestamps
    end
  end
end
