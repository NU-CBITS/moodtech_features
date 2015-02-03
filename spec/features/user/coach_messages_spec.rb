# filename: coach_messages_spec.rb

# this is to test the users functionality on the researcher dashboard.

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

# to run locally comment this line out
# describe 'Coach, Messages', type: :feature, sauce: true do

# to run on Sauce Labs comment this block out
describe 'Coach, Messages', type: :feature, sauce: false do
  before(:each) do
    Capybara.default_driver = :selenium
    visit ENV['Base_URL'] + '/users/sign_in'
    within('#new_user') do
      fill_in 'user_email', with: ENV['Clinician_Email']
      fill_in 'user_password', with: ENV['Clinician_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
    click_on 'Arms'
    expect(page).to have_content 'Listing Arms'
    click_on 'Arm 1'
    expect(page).to have_content 'Title: Arm 1'
    click_on 'Group 1'
    expect(page).to have_content 'Title: Group 1'
    click_on 'Messaging'
    click_on 'Messages'
    expect(page).to have_content 'Inbox'
    expect(page).to have_content 'Sent'
    expect(page).to have_content 'Compose'
  end

  # tests
  # Testing inbox
  it '- inbox' do
    click_on 'I like this app'
    expect(page).to have_content 'From TFD-1111'
    expect(page).to have_content 'This app is really helpful!'
  end

  # Testing reply
  it '- reply' do
    click_on 'I like this app'
    expect(page).to have_content 'This app is really helpful!'
    click_on 'Reply'
    fill_in 'message_body', with: 'This message is to test the reply functionality'
    click_on 'Send'
    expect(page).to have_content 'Message saved'
    expect(page).to have_content 'Inbox'
    expect(page).to have_content 'Sent'
    expect(page).to have_content 'Compose'
    expect(page).to have_content 'I like this app'

    visit ENV['Base_URL'] + '/participants/sign_in'
    within('#new_participant') do
      fill_in 'participant_email', with: ENV['Participant_Email']
      fill_in 'participant_password', with: ENV['Participant_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'

    visit ENV['Base_URL'] + '/navigator/contexts/MESSAGES'
    expect(page).to have_content 'Reply: I like this app'
  end

  # Testing sent box
  it '- sent box' do
    click_on 'Sent'
    expect(page).to have_content 'Try out the LEARN tool'
    click_on 'Try out the LEARN tool'
    expect(page).to have_content 'I think you will find it helpful.'
    click_on 'Messages'
    expect(page).to have_content 'Inbox'
    expect(page).to have_content 'Sent'
    expect(page).to have_content 'Compose'
    expect(page).to have_content 'I like this app'
  end

  # Testing compose
  it '- compose' do
    click_on 'Compose'
    expect(page).to have_content 'Compose Message'
    select 'TFD-1111', from: 'message_recipient_id'
    fill_in 'message_subject', with: 'Testing compose functionality'
    select 'Introduction to ThinkFeelDo', from: 'coach-message-link-selection'
    fill_in 'message_body', with: 'This message is to test the compose functionality.'
    click_on 'Send'
    expect(page).to have_content 'Message saved'
    expect(page).to have_content 'Inbox'
    expect(page).to have_content 'Sent'
    expect(page).to have_content 'Compose'
    expect(page).to have_content 'I like this app'

    visit ENV['Base_URL'] + '/participants/sign_in'
    within('#new_participant') do
      fill_in 'participant_email', with: ENV['Participant_Email']
      fill_in 'participant_password', with: ENV['Participant_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
    visit ENV['Base_URL'] + '/navigator/contexts/MESSAGES'
    expect(page).to have_content 'Testing compose functionality'
  end

  #Testing search functionality
  it "- search" do
    select 'TFD-1111', from: 'search'
    click_on 'Search'
    expect(page).to have_content 'I like this app'
  end
end