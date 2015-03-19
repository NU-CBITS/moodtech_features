# filename: coach_site_messages_spec.rb

describe 'Coach signs in and navigates to Site Messages tool',
         type: :feature, sauce: sauce_labs do
  before(:each) do
    sign_in_pt(ENV['Clinician_Email'], ENV['Clinician_Password'])

    click_on 'Arms'
    find('h1', text: 'Arms')

    click_on 'Arm 1'
    expect(page).to have_content 'Title: Arm 1'

    click_on 'Group 1'
    expect(page).to have_content 'Title: Group 1'

    click_on 'Messaging'
    click_on 'Site Messaging'
    expect(page).to have_content 'Listing Site Messages'
  end

  it 'creates and sends a new site message' do
    click_on 'New'
    expect(page).to have_content 'New site message'

    expect(page).to have_content 'stepped_care-no-reply@northwestern.edu'

    select 'TFD-1111', from: 'site_message_participant_id'
    fill_in 'site_message_subject', with: 'Testing site messaging'
    fill_in 'site_message_body',
            with: 'This message is intended to test the functionality of ' \
            'site messaging.'
    click_on 'Send'
    expect(page).to have_content 'Site message was successfully created.'

    expect(page).to have_content 'Participant: TFD-1111'

    expect(page).to have_content 'Subject: Testing site messaging'

    expect(page).to have_content 'Body: This message is intended to test the ' \
                                 'functionality of site messaging.'
  end

  it 'reviews a previously sent site message' do
    first(:link, 'Show').click
    expect(page).to have_content 'Participant: TFD-1111'

    expect(page).to have_content 'Subject: message subject'

    expect(page).to have_content 'Body: message body'
  end

  it 'uses breadcrumbs to return to home' do
    click_on 'Group'
    within('.breadcrumb') do
      click_on 'Home'
    end

    expect(page).to have_content 'Arms'
  end
end
