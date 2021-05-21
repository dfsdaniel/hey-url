# frozen_string_literal: true

class Url < ApplicationRecord
  validates :original_url, format: URI::regexp(%w[http https])
  has_many :clicks
  
  def generate_short_url_code
    self.short_url = SecureRandom.uuid[0..4].upcase
  end
end
