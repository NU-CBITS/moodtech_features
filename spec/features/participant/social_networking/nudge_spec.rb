# filename: nudge_spec.rb

describe 'Active participant in a social arm signs in,',
         type: :feature, sauce: sauce_labs do
  before do
    sign_in_pt(ENV['Participant_Email'], ENV['Participant_Password'])
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
        page.all('img')[2].click
      end
    end

    expect(page).to have_content 'clinician1@example.com nudged you!'
  end

  it 'expects to see nudge on landing page' do
    expect(page).to have_content 'nudged participant1'
  end
end
