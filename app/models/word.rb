class Word < ApplicationRecord
  has_one_attached :audio_data
  belongs_to :week

  alias_attribute :spelling, :title

  validates :spelling, presence: true
  before_save :create_audio_data
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
    if title_changed?
      create_audio_data
    end
  end

  def next_word
    index = week.words.index(self)
    week.words[index + 1]
  end
end
