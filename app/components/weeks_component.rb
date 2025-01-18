# frozen_string_literal: true

class WeeksComponent < ViewComponent::Base
  delegate :authenticated?, to: :helpers

  def weeks
    @weeks ||= Week.paginate(page: params[:page], per_page: 10).order(date: :desc)
  end

  def is_admin?
    authenticated?
  end
end
