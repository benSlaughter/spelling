# frozen_string_literal: true

class WeekComponent < ViewComponent::Base
  delegate :current_user, to: :helpers
  attr_reader :week

  def initialize(week:)
    @week = week
  end

  def wordsearch_completed?
    progress = WordsearchProgress.find_by(user: current_user, wordsearch: week.wordsearch)
    progress&.completed? || false
  end

  def guess_completed?
    progress = GuessProgress.find_by(user: current_user, week: week)
    progress&.completed? || false
  end

  def practice_path
    week_practice_path(week_id: week.id, id: week.words.first.id)
  end

  def scramble_path
    week_scramble_index_path(week_id: week.id)
  end

  def guess_path
    week_guess_path(week_id: week.id, id: week.words.first.id)
  end

  def is_admin?
    current_user&.admin?
  end
end
