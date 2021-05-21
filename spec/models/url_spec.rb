# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Url, type: :model do
  describe 'validations' do
    it 'validates original URL is a valid URL' do
      invalid_url = Url.new(original_url: 'some/url')
      expect(invalid_url).to_not be_valid
    end

    it 'validates short URL is present' do
      url = Url.new(original_url: 'http://www.google.com')
      url.generate_short_url_code()
      
      expect(url.short_url).to_not be_empty
    end

    it 'validates short URL has correct length' do
      url = Url.new(original_url: 'http://www.google.com')
      url.generate_short_url_code()

      expect(url.short_url.length).to eql(5)
    end
  end
end
