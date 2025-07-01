class GuessProgress < ApplicationRecord
  belongs_to :user
  belongs_to :week
  serialize :guessed_words, type: Array, coder: JSON

  def completed!
    update(completed: true)
  end
end
