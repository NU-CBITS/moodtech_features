#filename: message1_spec.rb

#this file is to test the messaging functionality

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

#to run locally comment this block out
# describe "Messages", type: :feature, sauce: true do
#   before(:each) do
#     visit ENV['Base_URL'] + '/participants/sign_in'
#     within('#new_participant') do
#       fill_in 'participant_email', with: ENV['Participant_Email']
#       fill_in 'participant_password', with: ENV['Participant_Password']
#     end
#     click_on 'Sign in'
#     expect(page).to have_content 'Signed in successfully'
#     visit ENV['Base_URL'] + '/navigator/contexts/MESSAGES'
#     expect(page).to have_content 'Inbox'
#   end

#to run on Sauce Labs comment this block out
  describe "Messages", type: :feature, sauce: false do
  before(:each) do
    Capybara.default_driver = :selenium
    visit ENV['Base_URL'] + '/participants/sign_in'
    within('#new_participant') do
      fill_in 'participant_email', with: ENV['Participant_Email']
      fill_in 'participant_password', with: ENV['Participant_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
    visit ENV['Base_URL'] + '/navigator/contexts/MESSAGES'
    expect(page).to have_content 'Inbox'
  end

#tests

    #Testing Compose a new message
    it "- compose new" do
      click_on 'Compose'
      expect(page).to have_content 'To Coach'
      within ("#new_message") do
        fill_in 'message_subject', with: 'New message'
        fill_in 'message_body', with: 'This is a test message to my moderator. Hello, Moderator! How are you??'
      end
      click_on 'Send'
      expect(page).to have_content 'Message saved'
    end

    #Testing reading a new message in inbox
    it "- read new" do
      click_on 'Sent'
      expect(page).to have_content 'To: Coach'
      click_on 'I like this app'
      expect(page).to have_content 'From You'
      expect(page).to have_content 'This app is really helpful!'
    end

    #Testing the reply functionality
    it "- reply" do
      click_on 'Try out the LEARN tool'
      expect(page).to have_content 'I think you will find it helpful.'
      click_on 'Reply'
      expect(page).to have_content 'To Coach'
      within ("#new_message") do
        fill_in 'message_body', with: 'Got it. Thanks!'
      end
      click_on 'Send'
      expect(page).to have_content 'Message saved'
    end

    #Testing composing a message from reading a message
    it "- compose while reading a message" do
      click_on 'Try out the LEARN tool'
      expect(page).to have_content 'I think you will find it helpful.'
      click_on 'Compose'
      expect(page).to have_content 'To Coach'
    end

    #Testing the cancel button in compose
    it "- cancel button" do
      click_on 'Compose'
      expect(page).to have_content 'To Coach'
      click_on 'Cancel'
      expect(page).to have_content 'Inbox'
    end

    #Testing the return button in compose
    it "- return button" do
      click_on 'Compose'
      expect(page).to have_content 'To Coach'
      click_on 'Return'
      expect(page).to have_content 'Inbox'
    end
end