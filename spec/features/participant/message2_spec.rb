#filename: message2_spec.rb

#this file is to test the messaging functionality

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

#to run locally comment this line out
# describe "Messages", :type => :feature, :sauce => true do
#   before(:each) do
#     visit ENV['Base_URL']+ '/participants/sign_in'
#     within("#new_participant") do
#       fill_in 'participant_email', :with => ENV['Alt_Participant_Email']
#       fill_in 'participant_password', :with => ENV['Alt_Participant_Password']
#     end
#     click_on 'Sign in'
#     expect(page).to have_content 'Signed in successfully'
#     visit ENV['Base_URL'] + '/navigator/contexts/MESSAGES'
#     expect(page).to have_content 'Inbox'
#   end

#to run on Sauce Labs comment this block out
describe "Messages", :type => :feature, :sauce => false do

  before(:each) do
    Capybara.default_driver = :selenium
    visit ENV['Base_URL']+ '/participants/sign_in'
    within("#new_participant") do
      fill_in 'participant_email', :with => ENV['Alt_Participant_Email']
      fill_in 'participant_password', :with => ENV['Alt_Participant_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
    visit ENV['Base_URL'] + '/navigator/contexts/MESSAGES'
    expect(page).to have_content 'Inbox'
  end

#tests

#Testing the links provided by a Coach in the messages
it "- accessing ALL links from a message in inbox" do
  click_on 'Check out the Introduction slideshow'
  expect(page).to have_content "Here's a link to the introduction slideshow:"
  click_on 'Introduction to ThinkFeelDo'
  expect(page).to have_content 'Welcome to ThiFeDo'
  click_on 'Done'
  expect(page).to have_content "What's on your mind?"
  end
end