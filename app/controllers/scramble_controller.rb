class ScrambleController < ApplicationController
  allow_unauthenticated_access

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
