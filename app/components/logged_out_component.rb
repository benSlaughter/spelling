class LoggedOutComponent < ViewComponent::Base
  renders_one :header

  def random_logged_out_image
    images = Dir[Rails.root.join("app/assets/images/logged_out/*")].map { |f| File.basename(f) }
    "logged_out/#{images.sample}" if images.any?
  end
end