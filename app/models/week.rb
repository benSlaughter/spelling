class Week < ApplicationRecord
  has_many :words, dependent: :destroy
  accepts_nested_attributes_for :words

  validates :date, presence: true
  validates :note, presence: true

  def display
    date.nil? ? "None" : date.strftime("%A, %d %B %Y")
  end
end
