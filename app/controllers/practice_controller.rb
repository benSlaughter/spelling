class PracticeController < ApplicationController
  allow_unauthenticated_access
  include Rails.application.routes.url_helpers

  helper_method :message
  helper_method :is_correct?

  def show
    @pagehead = "Spellings practice"
    @week = Week.find_by(id: params[:week_id])
    @word = Word.find_by(id: params[:id])
    @correct = params[:correct]

    redirect_to "/" unless @week.words.include?(@word)
  end

  def update
    @pagehead = "Spellings again"
    @week = Week.find_by(id: params[:week_id])
    @word = Word.find_by(id: params[:id])

    if word_params[:title].downcase == @word.title.downcase
      if @word.next_word.nil?
        render :result, status: 202
      else
        redirect_to week_practice_path(week_id: @week.id, id: @word.next_word.id, correct: true)
      end
    else
      redirect_to week_practice_path(week_id: @week.id, id: @word.id, correct: false)
    end
  end

  def is_correct?
    @correct == "true"
  end

  def message
    if @correct == "true"
      "Correct, well done!"
    else
      "Oops, try again!"
    end
  end

  def word_params
    params.expect(word: {})
  end
end
