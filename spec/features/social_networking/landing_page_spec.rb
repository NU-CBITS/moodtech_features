#filename: landing_page_spec.rb

#this file is to test the messaging functionality

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

#to run locally comment this line out
# describe "Social Networking landing page", :type => :feature, :sauce => true do
#   before(:each) do
#     visit ENV['Base_URL']+ '/participants/sign_in'
#     within("#new_participant") do
#       fill_in 'participant_email', :with => ENV['Participant_Email']
#       fill_in 'participant_password', :with => ENV['Participant_Password']
#     end
#     click_on 'Sign in'
#     expect(page).to have_content 'Signed in successfully'
#     visit ENV['Base_URL'] + '/navigator/contexts/MESSAGES'
#     expect(page).to have_content 'Inbox'
#   end

#to run on Sauce Labs comment this block out
describe "Social Networking landing page", :type => :feature, :sauce => false do

  before(:each) do
    Capybara.default_driver = :selenium
    visit ENV['Base_URL']+ '/participants/sign_in'
    within("#new_participant") do
      fill_in 'participant_email', :with => ENV['Participant_Email']
      fill_in 'participant_password', :with => ENV['Participant_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
    expect(page).to have_content "What's on your mind?"
  end

#tests
  it '- create a profile' do
    click_on 'Create a Profile'
    within('.modal-content') do
      expect(page).to have_content 'Start creating'
      find(:xpath, '//*[@id="profile-icon-selection"]/div[2]/div/div[2]/div[1]/div[3]').click
    end
    fill_in 'new-answer-description-781294868', :with => 'Running'
    find(:xpath, '//*[@id="question-781294868"]/form/div[2]/button').click
  end
end