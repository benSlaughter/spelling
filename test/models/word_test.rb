require "test_helper"

class WordTest < ActiveSupport::TestCase
  def setup
    @week = Week.create!(note: "Week 1", date: Date.today)
    @word = Word.create!(title: "example", week: @week)
  end

  test "is valid with valid attributes" do
    assert @word.valid?
  end

  test "is invalid without a spelling" do
    @word.title = nil
    assert_not @word.valid?
    assert_includes @word.errors[:spelling], "can't be blank"
  end

  test "spelling alias returns title" do
    assert_equal @word.title, @word.spelling
  end

  test "next_word returns the next word in the week" do
    word2 = Word.create!(title: "second", week: @week)
    assert_equal word2, @word.reload.next_word
  end

  test "create_audio_data attaches audio file" do
    @word.save!
    assert @word.audio_data.attached?
  end

  test "update_audio_data is called when title changes" do
    @word.save!
    @word.update!(title: "changed")
    assert @word.audio_data.attached?
  end
end
