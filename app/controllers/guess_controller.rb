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
    progress = GuessProgress.find_or_create_by(user: current_user, week: @week)
    @guessed = progress.guessed_words.include?(@word.title)
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

      # Track progress
      progress = GuessProgress.find_or_create_by(user: current_user, week: @week)
      progress.guessed_words ||= []
      unless progress.guessed_words.include?(@word.title)
        progress.guessed_words << @word.title
        current_user.earn_coins(@word.title.length) if progress.save
      end

      if @word.next_word
        redirect_to week_guess_path(@week, @word.next_word)
      else
        flash[:notice] += " You've completed all words for this week!"
        progress.completed!
        redirect_to week_path(@week)
      end

    else
      flash[:alert] = "Incorrect guess. Try again!"
      redirect_to week_guess_path(@week, @word)
    end
  end
end
