# frozen_string_literal: true

class WordsearchComponent < ViewComponent::Base
  attr_reader :letters, :words

  def initialize(letters:, words:)
    @letters = letters
    @words = words
  end

  def rows
    letters
  end

  def cols
    letters.first.size
  end
end
