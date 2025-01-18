# frozen_string_literal: true

class NavigationComponent < ViewComponent::Base
  delegate :authenticated?, :current_user, to: :helpers
  attr_reader :open_dialog

  def initialize(open_dialog:)
    @open_dialog = open_dialog
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

      if authenticated?
        list.with_avatar_item(
          src: "https://avatars.githubusercontent.com/u/103004183?v=4",
          username: current_user.username,
          href: "/",
          avatar_arguments: { shape: :square }
        )
        list.with_item(component_klass: Primer::Alpha::ActionList::Item, name: :logout, label: "Sign out", href: session_path, form_arguments: { method: :delete }) do |item|
          item.with_leading_visual_icon(icon: :"sign-out")
        end
      else
        list.with_item(label: "Sign in", content_arguments: { "data-show-dialog-id": "my-dialog" },) do |item|
          item.with_leading_visual_icon(icon: :"sign-in")
        end
      end
    end
  end

  def weeks
    @weeks ||= Week.last(5).reverse
  end
end
