require "test_helper"

class WeekTest < ActiveSupport::TestCase
  def setup
    @week = Week.create!(note: "Test week", date: Date.today)
  end

  test "is valid with valid attributes" do
    assert @week.valid?
  end

  test "is invalid without a date" do
    @week.date = nil
    assert_not @week.valid?
    assert_includes @week.errors[:date], "can't be blank"
  end

  test "is invalid without a note" do
    @week.note = nil
    assert_not @week.valid?
    assert_includes @week.errors[:note], "can't be blank"
  end

  test "display returns formatted date" do
    assert_equal @week.date.strftime("%A, %d %B %Y"), @week.display
  end

  test "display returns 'None' if date is nil" do
    @week.date = nil
    assert_equal "None", @week.display
  end

  test "creates wordsearch on create if words are present" do
    @week.words.create!(title: "testword")
    assert_difference "Wordsearch.count", 1 do
      Week.create!(note: "With word", date: Date.today, words_attributes: [ { title: "testword" } ])
    end
  end
end
