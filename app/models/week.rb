class Week < ApplicationRecord
  has_many :words, dependent: :destroy
  accepts_nested_attributes_for :words
  has_one :wordsearch, dependent: :destroy

  validates :date, presence: true
  validates :note, presence: true

  before_create :create_wordsearch
  before_update :update_wordsearch

  def display
    date.nil? ? "None" : date.strftime("%A, %d %B %Y")
  end

  def create_wordsearch
    return unless wordsearch.nil?
    return if words.empty?
    grid = Spelling::Grid.build_wordsearch(words.map(&:spelling))
    Wordsearch.create!(grid: grid.store_grid, week: self)
  end

  def update_wordsearch
    return create_wordsearch if wordsearch.nil?
    grid = Spelling::Grid.build_wordsearch(words.map(&:spelling))
    wordsearch.update(grid: grid.store_grid)
  end
end
