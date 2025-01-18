# frozen_string_literal: true

class WeekComponent < ViewComponent::Base
  delegate :authenticated?, to: :helpers
  attr_reader :week

  def initialize(week:)
    @week = week
  end

  def practice_path
    week_practice_path(week_id: week.id, id: week.words.first.id)
  end

  def is_admin?
    authenticated?
  end
end
