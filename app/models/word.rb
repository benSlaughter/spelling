class Word < ApplicationRecord
  has_one_attached :audio_data
  belongs_to :week

  alias_attribute :spelling, :title

  validates :spelling, presence: true
  before_create :create_audio_data
  before_update :update_audio_data

  def create_audio_data
    file = Tempfile.new(binmode: true)
    url = "http://translate.google.com/translate_tts?tl=en&ie=UTF-8&client=tw-ob&q=#{title}"
    content = URI.open(url).read
    file.write(content)
    file.rewind
    audio_data.attach(io: file, filename: "#{title}.mp3")
  end

  def update_audio_data
    if will_save_change_to_title?
      create_audio_data
    end
  end

  def guess_words
    words = []
    10.times { words << random_transform(title) }
    (words << title).uniq.last(4).shuffle
  end

  def next_word
    index = week.words.index(self)
    week.words[index + 1]
  end

  private

  def random_transform(word)
    methods = [ :add_letter, :remove_letter, :shuffle_letters ]
    method = methods.sample
    send(method, word)
  end

  def add_letter(word, random: false)
    chars = word.chars
    letters = random ? ("a".."z").to_a : chars[1..-1]
    chars.insert(random_location, letters.sample)
    chars.join
  end

  def remove_letter(word)
    return add_letter(word, random: true) if word.length <= 3
    chars = word.chars
    chars.delete_at(random_location)
    chars.join
  end

  def shuffle_letters(word)
    return add_letter(word, random: true) if word.length <= 3
    chars = word.chars
    idx = random_location
    chars[idx], chars[idx + 1] = chars[idx + 1], chars[idx]
    chars.join
  end

  # Never the first or last letter
  def random_location
    rand(title.length - 2) + 1
  end
end
