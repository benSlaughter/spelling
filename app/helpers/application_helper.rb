module ApplicationHelper
  def practice_path(**kwargs)
    week_practice_path(week_id: @week.id, id: @week.words.first.id, **kwargs)
  end
end
