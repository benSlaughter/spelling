class WordsearchController < ApplicationController
  def show
    @pagehead = "Spelling Wordsearch"
    @wordsearch = Wordsearch.find(params[:id])
    progress = WordsearchProgress.find_by(user: current_user, wordsearch: @wordsearch)
    grid_data = JSON.parse(@wordsearch.grid)
    respond_to do |format|
      format.html # renders show.html.erb by default
      format.json do
        render json: {
          grid: grid_data["grid"],
          positions: grid_data["positions"],
          words: @wordsearch.week.words.map(&:title),
          found_words: progress&.found_words || []
        }
      end
    end
  end

  def progress
    @wordsearch = Wordsearch.find(params[:id])
    @progress = WordsearchProgress.find_or_create_by(user: current_user, wordsearch: @wordsearch)
    word = params[:word].upcase
    unless @progress.found_words.include?(word)
      @progress.found_words << word
      @progress.save
      current_user.earn_coins(word.length) if @progress.save
    end
    head :ok
  end
end
