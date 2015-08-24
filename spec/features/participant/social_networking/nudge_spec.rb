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
    find_feed_item('nudged profile question participant')
    expect(page).to have_content 'nudged profile question participant'
  end

  it 'receives a nudge alert on profile page' do
    visit "#{ENV['Base_URL']}/social_networking/profile_page"
    if page.has_css?('.modal-content')
      within('.modal-content') do
        page.all('img')[2].click
      end
    end

    expect(page).to have_content 'TFD Moderator nudged you!'
  end

  it 'sees nudge on landing page' do
    find('h1', text: 'HOME')
    find_feed_item('nudged participant1')
    expect(page).to have_content 'nudged participant1'
  end
end
