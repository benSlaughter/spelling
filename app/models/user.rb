class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 72 }
  validates :email_address, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 254 }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 8 }, confirmation: true, if: -> { new_record? || !password.nil? }

  def possessive
    username.ends_with?("s") ? "#{username}'" : "#{username}'s"
  end

  def admin?
    is_a?(Admin)
  end

  def teacher?
    is_a?(Teacher)
  end

  def student?
    is_a?(Student)
  end
end
