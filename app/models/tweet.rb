class Tweet < ActiveRecord::Base
  validates :search_word, presence: true, length: { maximum:  100 }
  validates :name,        presence: true, length: { maximum:  100 }
  validates :full_text,   presence: true, length: { maximum:  500 }
  validates :uri,         presence: true, length: { maximum: 1000 }
end
