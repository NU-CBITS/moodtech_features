# filename: coach_site_messages_spec.rb

describe 'Coach signs in and navigates to Site Messages tool',
         type: :feature, sauce: sauce_labs do
  before do
    sign_in_user(ENV['Clinician_Email'], ENV['Clinician_Password'])
    click_on 'Arms'
    find('h1', text: 'Arms')
    click_on 'Arm 1'
    click_on 'Group 1'
    click_on 'Messaging'
    click_on 'Site Messaging'
  end

  it 'creates and sends a new site message' do
    click_on 'New'
    expect(page).to have_content 'stepped_care-no-reply@northwestern.edu'

    select 'TFD-1111', from: 'site_message_participant_id'
    fill_in 'site_message_subject', with: 'Testing site messaging'
    fill_in 'site_message_body',
            with: 'This message is intended to test the functionality of ' \
            'site messaging.'
    click_on 'Send'
    expect(page).to have_content 'Site message was successfully created.' \
                                 "\nParticipant: TFD-1111" \
                                 "\nSubject: Testing site messaging" \
                                 "\nBody: This message is intended to test " \
                                 'the functionality of site messaging.'

    click_on 'Back'
    within('tr:nth-child(2)') do
      expect(page).to have_content 'TFD-1111  Testing site messaging  ' \
                                   'This message is intended to test the ' \
                                   'functionality of site messaging.'
    end
  end

  it 'reviews a previously sent site message' do
    first(:link, 'Show').click
    expect(page).to have_content 'Participant: TFD-1111' \
                                 "\nSubject: message subject" \
                                 "\nBody: message body"
  end

  it 'uses breadcrumbs to return to home' do
    click_on 'Group'
    within('.breadcrumb') do
      click_on 'Home'
    end

    expect(page).to have_content 'Arms'
  end
end
