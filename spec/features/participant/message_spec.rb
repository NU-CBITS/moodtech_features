# filename: message1_spec.rb

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

describe 'Active participant in group 1 signs in, navigates to MESSAGES,',
         type: :feature, sauce: sauce_labs do
  before(:each) do
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

  it 'composes a new message' do
    click_on 'Compose'
    expect(page).to have_content 'To Coach'

    within('#new_message') do
      fill_in 'message_subject', with: 'New message'
      fill_in 'message_body',
              with: 'This is a test message to my moderator. ' \
              'Hello, Moderator! How are you??'
    end

    click_on 'Send'
    expect(page).to have_content 'Message saved'
  end

  it 'reads a sent message' do
    click_on 'Sent'
    expect(page).to have_content 'To: Coach'

    click_on 'I like this app'
    expect(page).to have_content 'From You'

    expect(page).to have_content 'This app is really helpful!'
  end

  it 'reads and replies to a received message' do
    click_on 'Try out the LEARN tool'
    expect(page).to have_content 'I think you will find it helpful.'

    click_on 'Reply'
    expect(page).to have_content 'To Coach'

    within('#new_message') do
      fill_in 'message_body', with: 'Got it. Thanks!'
    end

    click_on 'Send'
    expect(page).to have_content 'Message saved'
  end

  it 'composes a message from reading a message' do
    click_on 'Try out the LEARN tool'
    expect(page).to have_content 'I think you will find it helpful.'

    click_on 'Compose'
    expect(page).to have_content 'To Coach'
  end

  it 'uses the cancel button within compose message' do
    click_on 'Compose'
    expect(page).to have_content 'To Coach'

    click_on 'Cancel'
    expect(page).to have_content 'Inbox'
  end

  it 'uses return button within compose message' do
    click_on 'Compose'
    expect(page).to have_content 'To Coach'

    click_on 'Return'
    expect(page).to have_content 'Inbox'
  end
end

describe 'Active participant in group 3 signs in, navigates to MESSAGES',
         type: :feature, sauce: sauce_labs do
  before(:each) do
    visit ENV['Base_URL'] + '/participants/sign_in'
    within('#new_participant') do
      fill_in 'participant_email', with: ENV['Alt_Participant_Email']
      fill_in 'participant_password', with: ENV['Alt_Participant_Password']
    end

    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'

    visit ENV['Base_URL'] + '/navigator/contexts/MESSAGES'
    expect(page).to have_content 'Inbox'
  end

  it 'accesses a link from a message in inbox' do
    click_on 'Check out the Introduction slideshow'
    expect(page).to have_content "Here's a link to the introduction slideshow:"

    click_on 'Introduction to ThinkFeelDo'
    expect(page).to have_content 'Welcome to ThiFeDo'

    click_on 'Done'
    expect(page).to have_content 'HOME'
  end
end
