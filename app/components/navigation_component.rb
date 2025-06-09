# frozen_string_literal: true

class NavigationComponent < ViewComponent::Base
  delegate :authenticated?, :current_user, to: :helpers

  def render?
    authenticated?
  end

  def navigation_sidebar
    render(Primer::Beta::NavList.new(aria: { label: "Navigation menu" })) do |list|
      list.with_item(label: "All Spellings", href: weeks_path) do |item|
        item.with_leading_visual_icon(icon: :home)
      end
      list.with_divider

      weeks.each do |week|
        list.with_item(label: week.display, href: week_path(week)) do |item|
          item.with_leading_visual_icon(icon: :"paper-airplane")
        end
      end

      list.with_divider
    end
  end

  def weeks
    @weeks ||= Week.last(5).reverse
  end
end
