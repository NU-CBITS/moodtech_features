# filename: coach_messages_spec.rb

describe 'Coach signs in and navigates to messages tool for Group 1',
         type: :feature, sauce: sauce_labs do
  before do
    sign_in_user(ENV['Clinician_Email'], ENV['Clinician_Password'])
    click_on 'Arms'
    find('h1', text: 'Arms')
    click_on 'Arm 1'
    click_on 'Group 1'
    click_on 'Messaging'
    click_on 'Messages'
  end

  it 'reads a received message' do
    click_on 'I like this app'
    expect(page).to have_content 'From TFD-1111'

    expect(page).to have_content 'This app is really helpful!'
  end

  it 'replies to a message' do
    click_on 'I like this app'
    click_on 'Reply'
    fill_in 'message[body]',
            with: 'This message is to test the reply functionality'
    click_on 'Send'
    expect(page).to have_content 'Message saved'

    sign_in_pt(ENV['Participant_Email'], ENV['Participant_Password'])
    visit "#{ENV['Base_URL']}/navigator/contexts/MESSAGES"
    expect(page).to have_content 'Reply: I like this app'
  end

  it 'reads a sent message' do
    click_on 'Sent'
    click_on 'Try out the LEARN tool'
    expect(page).to have_content 'I think you will find it helpful.'
  end

  it 'composes a message' do
    click_on 'Compose'
    select 'TFD-1111', from: 'message_recipient_id'
    fill_in 'message_subject', with: 'Testing compose functionality'
    select 'Intro', from: 'coach-message-link-selection'
    fill_in 'message_body',
            with: 'This message is to test the compose functionality.'
    click_on 'Send'
    expect(page).to have_content 'Message saved'

    sign_in_pt(ENV['Participant_Email'], ENV['Participant_Password'])
    visit "#{ENV['Base_URL']}/navigator/contexts/MESSAGES"
    expect(page).to have_content 'Testing compose functionality'
  end

  it 'searches for a specific participants messages' do
    select 'TFD-1111', from: 'search'
    click_on 'Search'
    expect(page).to have_content 'I like this app'

    click_on 'Sent'
    expect(page).to have_content 'Try out the LEARN tool'

    expect(page).to_not have_content 'Check out the Introduction slideshow'
  end

  it 'uses breadcrumbs to return to home' do
    click_on 'Group'
    within('.breadcrumb') do
      click_on 'Home'
    end

    expect(page).to have_content 'Arms'
  end
end
