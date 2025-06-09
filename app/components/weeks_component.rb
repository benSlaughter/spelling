# frozen_string_literal: true

class WeeksComponent < ViewComponent::Base
  delegate :authenticated?, :current_user, to: :helpers

  def render?
    authenticated?
  end

  def weeks
    @weeks ||= Week.paginate(page: params[:page], per_page: 10).order(date: :desc)
  end

  def is_admin?
    current_user&.admin?
  end
end
