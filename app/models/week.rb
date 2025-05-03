class Week < ApplicationRecord
  has_many :words, dependent: :destroy
  accepts_nested_attributes_for :words
  has_one :wordsearch, dependent: :destroy

  validates :date, presence: true
  validates :note, presence: true

  def display
    date.nil? ? "None" : date.strftime("%A, %d %B %Y")
  end

  def create_wordsearch
    grid = Spelling::Grid.build_wordsearch(words.map(&:spelling))
    Wordsearch.new(grid: grid.store_grid, week: self).save
  end
end
