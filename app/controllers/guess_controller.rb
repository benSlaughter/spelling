class GuessController < ApplicationController
  def index
    @pagehead = "Spellings guessing"
    @week = Week.find_by(id: params[:week_id])
    @words = @week.words
  end

  def show
    @week = Week.find_by(id: params[:week_id])
    @word = @week.words.find_by(id: params[:id])
    
    if @word.nil?
      flash[:alert] = "Word not found for this week."
      redirect_to week_path(@week)
      return
    end
    
    @words = @word.guess_words
  end

  def try
    @week = Week.find_by(id: params[:week_id])
    @word = @week.words.find_by(id: params[:id])
    validate_guess
  end

  private

  def validate_guess
    guess = params[:guess].strip.downcase
    if guess == @word.title.downcase
      flash[:notice] = "Correct! You guessed '#{@word.title}'"
      current_user.earn_coins(@word.title.length)

      if @word.next_word
        redirect_to week_guess_path(@week, @word.next_word)
      else
        flash[:notice] += " You've completed all words for this week!"
        redirect_to week_path(@week)
      end
      
    else
      flash[:alert] = "Incorrect guess. Try again!"
      redirect_to week_guess_path(@week, @word)
    end
  end
end
