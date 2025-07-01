class WordsearchProgress < ApplicationRecord
  belongs_to :user
  belongs_to :wordsearch
  serialize :found_words, type: Array, coder: JSON

  def completed!
    update(completed: true)
  end
end
