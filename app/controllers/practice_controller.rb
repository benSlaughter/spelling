class PracticeController < ApplicationController
  allow_unauthenticated_access
  include Rails.application.routes.url_helpers

  def show
    @pagehead = "Spellings practice"
    @week = Week.find_by(id: params[:week_id])
    @word = Word.find_by(id: params[:id])
    @result = params[:result]

    redirect_to "/" unless @week.words.include?(@word)
  end

  def update
    @pagehead = "Spellings practice"
    @week = Week.find_by(id: params[:week_id])
    @word = Word.find_by(id: params[:id])

    if word_params[:title].downcase == @word.title.downcase
      if @word.next_word.nil?
        render :result
      else
        redirect_to week_practice_path(week_id: @week.id, id: @word.next_word.id, result: "Correct!")
      end
    else
      @word.errors.add(:title, "incorrect")
      @result = "Oops, try again!"
      render :show
    end
      
  end

  def word_params
    params.expect(word: {})
  end
end
