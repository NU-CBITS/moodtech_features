#filename: coach_messages_spec.rb

#this is to test the users functionality on the researcher dashboard.

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

#to run locally comment this line out
# describe "Coach, Messages", :type => :feature, :sauce => true do

#to run on Sauce Labs comment this block out
describe "Coach, Messages", :type => :feature, :sauce => false do

  before(:each) do
    Capybara.default_driver = :selenium
    visit ENV['Base_URL']+ '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', :with => ENV['User_Email']
      fill_in 'user_password', :with => ENV['User_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
    click_on 'Groups'
    expect(page).to have_content 'Listing Groups'
    # click_on 'fake'
    expect(page).to have_content 'Participant Info'
    click_on 'Messaging'
    click_on 'Messages'
    expect(page).to have_content 'Inbox'
    # expect(page).to have_content 'Sent'
    expect(page).to have_content 'Compose'
  end

#tests
  #Testing inbox
  it "- inbox" do
    click_on 'This message is a test to my coach'
    expect(page).to have_content 'This message is for testing the inbox functionality on the coach dashboard.'
  end

  #Testing reply
  it "- reply" do
    click_on 'This message is a test to my coach'
    expect(page).to have_content 'This message is for testing the inbox functionality on the coach dashboard.'
    click_on 'Reply'
    expect(page).to have_content 'To You'
    fill_in 'message_body', :with => 'This message is to test the reply functionality'
    click_on 'Send'
    expect(page).to have_content 'Message saved'
    expect(page).to have_content 'Inbox'
    expect(page).to have_content 'Sent'
    expect(page).to have_content 'Compose'
    expect(page).to have_content 'This message is a test to my coach'
  end

  #Testing sent box
  it "- sent box" do
    click_on 'Sent'
    expect(page).to have_content 'Testing sent message'
    click_on 'Testing sent message'
    expect(page).to have_content 'From You'
    expect(page).to have_content 'This message is to a participant for testing the sent box functionality.'
    click_on 'Messages'
    expect(page).to have_content 'Inbox'
    expect(page).to have_content 'Sent'
    expect(page).to have_content 'Compose'
    expect(page).to have_content 'This message is a test to my coach'
  end

  #Testing compose
  it "- compose" do
    click_on 'Compose'
    expect(page).to have_content 'Compose Message'
    select 'ChrisBrennerTest', :from => 'message_recipient_id'
    fill_in 'message_subject', :with => 'Testing compose functionality'
    select 'Introduction to ThinkFeelDo', :from => 'coach-message-link-selection'
    fill_in 'message_body', :with => 'This message is to test the compose functionality.'
    click_on 'Send'
    expect(page).to have_content 'Message saved'
    expect(page).to have_content 'Inbox'
    expect(page).to have_content 'Sent'
    expect(page).to have_content 'Compose'
    expect(page).to have_content 'This message is a test to my coach'
  end

  #Testing search functionality
  it "- search" do
    select 'ChrisBrennerTest', :from => 'search'
    click_on 'Search'
    expect(page).to have_content 'This message is a test to my coach'
  end
end