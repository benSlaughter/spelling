# Wordsearch generator
require "json"

module Spelling
  class Grid
    def self.parse(str)
      data = JSON.parse(str)
      grid = grid_from_string(data["grid"])
      positions = data["positions"].transform_values! { |v| v.transform_keys(&:to_sym) }
      words = positions.keys

      new(words, grid: grid, positions: positions)
    end

    def self.build_wordsearch(words, max_retries = 10, max_increases = 5)
      me = new(words, max_retries, max_increases)
      me.build_wordsearch
      me
    end

    attr_reader :positions, :size, :words, :grid, :max_retries, :max_increases

    def initialize(words, max_retries = 10, max_increases = 5, grid: nil, positions: nil)
      @words = words.map(&:downcase)
      @size = words.map(&:length).max + 2
      @max_retries = max_retries
      @max_increases = max_increases
      @grid = grid || Array.new(size) { Array.new(size, nil) }
      @positions = positions
    end

    def build_wordsearch
      max_increases.times do |increases|
        max_retries.times do |retries|
          reset_grid

          if generate_wordsearch
            fill_random_letters
            return
          end

          puts "Unable to fit words in #{size}x#{size} grid, retrying (attempts ##{retries + 1})..."
        end
        @size += 1
        puts "Increasing grid size to #{size}x#{size} and retrying (attempts ##{increases + 1})..."
      end
      raise "Failed to fit all words after #{max_retries} increases. Last tried grid: #{size}x#{size}"
    end

    def generate_wordsearch
      @words.each do |word|
        unless place_word(word)
          puts "Unable to place word: #{word.inspect} after 100 attempts!"
          return false
        end
      end

      true
    end

    def place_word(word)
      placed = false
      attempts = 0
      direction = %w[right down diagonal].sample

      while !placed && attempts < 100
        if direction == "right"
          row = rand(size)
          col = random_position(word)
          can_place = (0...word.length).all? do |i|
            grid[row][col + i].nil? || grid[row][col + i] == word[i]
          end
          if can_place
            (0...word.length).each { |i| grid[row][col + i] = word[i] }
            placed = true
          end
        elsif direction == "down"
          col = rand(size)
          row = random_position(word)
          can_place = (0...word.length).all? do |i|
            grid[row + i][col].nil? || grid[row + i][col] == word[i]
          end
          if can_place
            (0...word.length).each { |i| grid[row + i][col] = word[i] }
            placed = true
          end
        else # diagonal
          col = random_position(word)
          row = random_position(word)
          can_place = (0...word.length).all? do |i|
            grid[row + i][col + i].nil? || grid[row + i][col + i] == word[i]
          end
          if can_place
            (0...word.length).each { |i| grid[row + i][col + i] = word[i] }
            placed = true
          end
        end

        attempts += 1
      end
      positions[word] = { row: row, col: col, direction: direction }
      placed
    end

    def print_grid
      grid.each { |row| puts row.join(" ") }
      puts
      puts words.join("\n")
      puts
      self
    end

    def store_grid
      build_wordsearch if positions.nil?
      { grid: grid_string, positions: positions }.to_json
    end

    private

    def lookup_table(word)
      max_cells = size - word.length
      {
        "right" => (0...size).to_a.product((0..max_cells).to_a)
      }
    end

    def reset_grid
      @grid = Array.new(size) { Array.new(size, nil) }
      @words = words.shuffle
      @positions = {}
    end

    def fill_random_letters
      fill_letters = ("a".."z").to_a
      fill_letters.delete_if { |l| words.join.include?(l) }
      fill_letters += [ "a", "e", "i", "o", "u" ]

      grid.map! do |row|
        row.map { |c| c.nil? ? fill_letters.sample : c }
      end
    end

    def random_position(word)
      rand(0..(size - word.length))
    end

    def grid_string
      grid.map { |row| row.join("") }.join(" ")
    end

    def self.grid_from_string(str)
      str.split(" ").map { |row| row.chars }
    end
  end
end
