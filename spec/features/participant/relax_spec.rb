# filename: do1_spec.rb

describe 'Active participant signs in, navigates to RELAX tool,',
         type: :feature, sauce: sauce_labs do
  before do
    sign_in_pt(ENV['Participant_Email'], ENV['Participant_Password'])

    visit "#{ENV['Base_URL']}/navigator/contexts/RELAX"
    expect(page).to have_content 'RELAX Home'
  end

  it 'listens to a relax exercise' do
    click_on 'Autogenic Exercises'
    within('.jp-controls') do
      find('.jp-play').click
    end

    click_on 'Next'
    expect(page).to have_content 'Home'

    visit ENV['Base_URL']
    find_feed_item('Listened to a Relaxation Exercise: Audio!')
    expect(page).to have_content 'Listened to a Relaxation Exercise: Audio!'
  end
end
