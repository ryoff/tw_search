class Tweet < ActiveRecord::Base
  validates :search_word, presence: true, length: { maximum:  100 }
  validates :name,        presence: true, length: { maximum:  100 }
  validates :full_text,   presence: true, length: { maximum:  500 }
  validates :uri,         presence: true, length: { maximum: 1000 }

  def self.last_since_id(word)
    where(search_word: word).last.try(:since_id) || 0
  end

  def self.find_by_word_and_since_id(word, since_id)
    where(search_word: word).find_by(since_id: since_id)
  end
end
