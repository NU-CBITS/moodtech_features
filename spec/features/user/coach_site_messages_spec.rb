# filename: coach_site_messages_spec.rb

describe 'Coach signs in, navigates to Site Messages tool,',
         type: :feature, sauce: sauce_labs do
  before do
    unless ENV['safari']
      sign_in_user(ENV['Clinician_Email'], 'TFD Moderator',
                   ENV['Clinician_Password'])
    end

    visit "#{ENV['Base_URL']}/think_feel_do_dashboard/arms"
    click_on 'Arm 1'
    click_on 'Group 1'
    click_on 'Messaging'
    click_on 'Site Messaging'
  end

  it 'creates and sends a new site message' do
    click_on 'New'
    expect(page).to have_content 'moodtech-no-reply@northwestern.edu'

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
                                   'functionality of site messaging. ' \
                                   "#{Date.today.strftime('%b %d %Y')}"
    end
  end

  it 'reviews a previously sent site message' do
    within('tr', text: 'message subject') do
      click_on 'Show'
    end

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
