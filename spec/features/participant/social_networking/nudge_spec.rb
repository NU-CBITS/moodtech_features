# filename: nudge_spec.rb

describe 'Active participant in a social arm is signed in,',
         type: :feature, sauce: sauce_labs do
  before do
    sign_in_pt(ENV['Participant_Email'], ENV['Participant_Password'])

    expect(page).to have_content "What's on your mind?"
  end

  it 'nudges another participant' do
    visit "#{ENV['Base_URL']}/social_networking/profile_page/596136196"
    click_on 'Nudge'
    expect(page).to have_content 'Nudge sent!'

    visit ENV['Base_URL']
    expect(page).to have_content 'nudged profile question participant'
  end

  it 'receives a nudge alert on profile page' do
    visit "#{ENV['Base_URL']}/social_networking/profile_page"
    if page.has_css?('.modal-content')
      within('.modal-content') do
        expect(page).to have_content 'Start creating'

        page.all('img')[2].click
      end

      expect(page).to have_css '.alert.alert-info'

      expect(page).to have_content 'clinician1@example.com nudged you!'

    else
      expect(page).to have_css '.alert.alert-info'

      expect(page).to have_content 'clinician1@example.com nudged you!'
    end
  end

  it 'expects to see nudge on landing page' do
    expect(page).to have_content 'nudged participant1'
  end
end
