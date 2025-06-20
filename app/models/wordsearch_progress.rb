class WordsearchProgress < ApplicationRecord
  belongs_to :user
  belongs_to :wordsearch
  serialize :found_words, type: Array, coder: JSON
end
