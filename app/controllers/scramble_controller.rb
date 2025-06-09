class ScrambleController < ApplicationController
  def index
    @pagehead = "Spellings scramble"
    @week = Week.find_by(id: params[:week_id])
    @words = @week.words
  end

  private

  def word_params
    params.expect(word: {})
  end
end
