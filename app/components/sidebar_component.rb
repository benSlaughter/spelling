# frozen_string_literal: true

class SidebarComponent < ViewComponent::Base
  delegate :authenticated?, :current_user, to: :helpers

  def last_week
    @last_week ||= Week.last
  end

  def avatar_params
    {
      src: "https://api.dicebear.com/9.x/fun-emoji/svg?seed=#{current_user.username}",
      username: current_user.username,
      href: users_path,
      avatar_arguments: { shape: :square }
    }
  end
end
