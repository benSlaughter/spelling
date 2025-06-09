# frozen_string_literal: true

class SideProfileComponent < ViewComponent::Base
  delegate :authenticated?, :current_user, to: :helpers

  def profile_sidebar
    render(Primer::Beta::NavList.new(aria: { label: "Navigation menu" })) do |list|
      if authenticated?
        list.with_avatar_item(
          src: "https://api.dicebear.com/9.x/fun-emoji/svg?seed=#{current_user.username}",
          username: current_user.username,
          href: users_path,
          avatar_arguments: { shape: :square }
        )
        list.with_item(component_klass: Primer::Alpha::ActionList::Item, name: :logout, label: "Sign out", href: session_path, form_arguments: { method: :delete }) do |item|
          item.with_leading_visual_icon(icon: :"sign-out")
        end
      end
    end
  end
end