# filename: feel1_spec.rb

describe 'Active participant in group 1 signs in, navigates to FEEL tool,',
         type: :feature, sauce: sauce_labs do
  before do
    sign_in_pt(ENV['Participant_Email'], ENV['Participant_Password'])
    visit "#{ENV['Base_URL']}/navigator/contexts/FEEL"
  end

  it 'completes Tracking Your Mood' do
    click_on 'Tracking Your Mood'
    select '6', from: 'mood[rating]'
    click_on 'Next'
    expect(page).to have_content 'Mood saved'

    click_on 'Next'
    expect(page).to have_content 'Feeling Tracker Landing'
  end
end

describe 'Active participant in group 3 signs in, navigates to FEEL tool,',
         type: :feature, sauce: sauce_labs do
  before do
    sign_in_pt(ENV['Alt_Participant_Email'], ENV['Alt_Participant_Password'])
    visit "#{ENV['Base_URL']}/navigator/contexts/FEEL"
  end

  it 'completes Tracking Your Mood & Emotions' do
    click_on 'Tracking Your Mood & Emotions'
    select '6', from: 'mood[rating]'
    click_on 'Next'
    expect(page).to have_content 'You just rated your mood as a 6 (Good)'

    select 'anxious', from: 'emotional_rating_emotion_id'
    select 'negative', from: 'emotional_rating_is_positive'
    select '4', from: 'emotional_rating[rating]'
    click_on 'Add Emotion'
    within '#subcontainer-1' do
      fill_in 'emotional_rating_name', with: 'crazy'
      select 'negative', from: 'emotional_rating_is_positive'
      select '8', from: 'emotional_rating[rating]'
    end

    click_on 'Next'
    expect(page).to have_content 'Emotional Rating saved'

    one_week_ago = Date.today - 6
    one_month_ago = Date.today - 27
    expect(page).to have_content "#{one_week_ago.strftime('%b %d %Y')} - " \
                                 "#{Date.today.strftime('%b %d %Y')}"

    find('.btn.btn-default', text: '28 day').click
    expect(page).to have_content "#{one_month_ago.strftime('%b %d %Y')} - " \
                                 "#{Date.today.strftime('%b %d %Y')}"

    find('.btn.btn-default', text: '7 Day').click
    click_on 'Previous Period'
    one_week_ago_1 = Date.today - 7
    two_weeks_ago = Date.today - 13
    expect(page).to have_content "#{two_weeks_ago.strftime('%b %d %Y')} - " \
                                 "#{one_week_ago_1.strftime('%b %d %Y')}"

    click_on 'Next'
    expect(page).to have_content 'Feeling Tracker Landing'
  end

  it 'views recent ratings in Your Recent Mood & Emotions' do
    click_on 'Your Recent Moods & Emotions'
    expect(page).to have_content 'Positive and Negative Emotions'

    expect(page).to have_css('.bar.positive', count: 1)

    expect(page).to have_css('.bar.negative', count: 1)

    click_on 'Next'
    expect(page).to have_content 'Feeling Tracker Landing'
  end

  it 'uses navbar functionality in all of FEEL' do
    visit "#{ENV['Base_URL']}/navigator/modules/86966983"
    click_on 'FEEL'
    click_on 'Your Recent Moods & Emotions'
    expect(page).to have_content 'Positive and Negative Emotions'

    click_on 'FEEL'
    click_on 'Tracking Your Mood & Emotions'
    expect(page).to have_content 'Rate your Mood'

    click_on 'FEEL'
    click_on 'FEEL Home'
    expect(page).to have_content 'Feeling Tracker Landing'
  end
end
