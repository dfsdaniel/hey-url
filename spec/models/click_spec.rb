# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Click, type: :model do
  describe 'validations' do
    it 'validates url_id is valid' do
      click = Click.new(platform: 'some-platform', browser: 'some-browser')
      expect(click).to_not be_valid
    end

    it 'validates browser is not null' do
      click = Click.new(url_id: 1, platform: 'some-platform')
      expect(click).to_not be_valid
    end

    it 'validates platform is not null' do
      click = Click.new(url_id: 1, browser: 'some-browser')
      expect(click).to_not be_valid
    end

    it 'validates can create a click object correctly' do
      url = Url.new(original_url: 'https://www.google.com')
      click = Click.new(url: url, platform: 'some-platform', browser: 'some-browser')
      expect(click).to be_valid
    end
  end
end
