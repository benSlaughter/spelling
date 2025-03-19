class ScrabbleController < ApplicationController
  allow_unauthenticated_access

  def show
    @pagehead = "Spellings scrabble"
    @week = Week.find_by(id: params[:week_id])
    @word = Word.find_by(id: params[:id])
    @letters = @word.title.split("").shuffle
  end

  private

  def word_params
    params.expect(word: {})
  end
end