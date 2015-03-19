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
    expect(page).to have_content 'Yay'
    within('.jp-controls') do
      find('.jp-play').click
    end

    click_on 'Next'
    expect(page).to have_content 'RELAX Home'

    visit ENV['Base_URL']
    expect(page).to have_content 'Listened to a Relaxation Exercise: Audio!'
  end
end
