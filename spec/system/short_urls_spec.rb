# frozen_string_literal: true

require 'rails_helper'
require 'webdrivers'

# WebDrivers Gem
# https://github.com/titusfortner/webdrivers
#
# Official Guides about System Testing
# https://api.rubyonrails.org/v5.2/classes/ActionDispatch/SystemTestCase.html

RSpec.describe 'Short Urls', type: :system do
  before do
    driven_by :selenium, using: :chrome
    # If using Firefox
    # driven_by :selenium, using: :firefox
    #
    # If running on a virtual machine or similar that does not have a UI, use
    # a headless driver
    # driven_by :selenium, using: :headless_chrome
    # driven_by :selenium, using: :headless_firefox
  end

  describe 'index' do
    it 'shows a list of short urls' do
      url_list = create_list(:url, 20)

      visit root_path
      expect(page).to have_text('HeyURL!')
      expect(page).to have_selector('.card-title', text: 'Create a new short URL')
      expect(page).to have_selector('#url_original_url')
      expect(page).to have_button('shorten-url-button')
      expect(page).to have_selector('table')
      
      # expect page to show only 10 urls
      expect(find('table tbody')).to have_css('tr', count: 10)
    end
  end

  describe 'show' do
    it 'shows a panel of stats for a given short url' do
      url = create(:url)
      visit url_path(url.short_url)
      
      expect(page).to have_text("Stats for")
      expect(page).to have_text("Created #{url.created_at.strftime('%b %d, %Y')}")
      expect(page).to have_text("Original URL: #{url.original_url}")
      
      # Check if charts are displayed
      expect(page).to have_selector('#total-clicks-chart')
      expect(page).to have_selector('#platforms-chart')
      expect(page).to have_selector('#browsers-chart')
    end

    context 'when not found' do
      it 'shows a 404 page' do
        visit url_path('NOTFOUND')
        expect(page).to have_text('This URL doesn\'t exists!')
      end
    end
  end

  describe 'create' do
    context 'when url is valid' do
      it 'creates the short url' do
        visit '/'
        
        # check if the table is empty
        expect(find('table tbody')).to have_no_css('*')
        
        fill_in('url[original_url]', with: 'http://www.google.com')
        click_button('shorten-url-button')
        
        # check if the table has children
        expect(find('table tbody')).to have_css('*')
      end

      # it 'redirects to the home page' do
      #   visit '/'
      #   # add more expections
      # end
    end

    context 'when url is invalid' do
      it 'does not create the short url and shows a message' do
        visit '/'
        
        # check if the table is empty
        expect(find('table tbody')).to have_no_css('*')

        # check if error message is not displayed
        expect(page).to_not have_selector('.card-panel.notice')

        fill_in('url[original_url]', with: 'some-invalid-url')
        click_button('shorten-url-button')

        # check if the table keep empty
        expect(find('table tbody')).to have_no_css('*')

        # check if error message is displayed with correct text
        expect(page).to have_selector('.card-panel.notice', text: 'This URL is not valid. Please try again.')
      end

      # it 'redirects to the home page' do
      #   visit '/'
      #   # add more expections
      # end
    end
  end

  describe 'visit' do
    it 'redirects the user to the original url' do
      url = Url.new(original_url: 'https://www.google.com')
      url.generate_short_url_code()
      url.save

      visit visit_path(url.short_url)
      
      expect(current_url).to have_text(url.original_url)
    end

    context 'when not found' do
      it 'shows a 404 page' do
        visit visit_path('NOTFOUND')

        expect(page).to have_text('This URL doesn\'t exists!')
      end
    end
  end
end
