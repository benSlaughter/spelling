class WordsearchController < ApplicationController
  def index
    @pagehead = "Spellings wordsearch"
    @week = Week.find_by(id: params[:week_id])
    @wordsearch = @week.wordsearch
    @grid = Spelling::Grid.parse(@wordsearch.grid)
  end
end
