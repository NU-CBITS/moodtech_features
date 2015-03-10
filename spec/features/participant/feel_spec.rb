# filename: feel1_spec.rb

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

# tests
describe 'Active participant in group 1 signs in, navigates to FEEL tool,',
         type: :feature, sauce: sauce_labs do
  before(:each) do
    visit ENV['Base_URL'] + '/participants/sign_in'
    within('#new_participant') do
      fill_in 'participant_email', with: ENV['Participant_Email']
      fill_in 'participant_password', with: ENV['Participant_Password']
    end

    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'

    visit ENV['Base_URL'] + '/navigator/contexts/FEEL'
    expect(page).to have_content 'Tracking Your Mood'
  end

  it 'completes Tracking Your Mood' do
    click_on 'Tracking Your Mood'
    expect(page).to have_content 'Rate your Mood'

    select '6', from: 'mood[rating]'
    click_on 'Next'
    expect(page).to have_content 'Mood saved'

    expect(page).to have_content 'Positive and Negative Emotions'

    click_on 'Next'
    expect(page).to have_content 'Feeling Tracker Landing'
  end
end

describe 'Active participant in group 3 signs in, navigates to FEEL tool,',
         type: :feature, sauce: sauce_labs do
  before(:each) do
    visit ENV['Base_URL'] + '/participants/sign_in'
    within('#new_participant') do
      fill_in 'participant_email', with: ENV['Alt_Participant_Email']
      fill_in 'participant_password', with: ENV['Alt_Participant_Password']
    end

    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'

    visit ENV['Base_URL'] + '/navigator/contexts/FEEL'
    expect(page).to have_content 'Tracking Your Mood & Emotions'
  end

  it 'completes Tracking Your Mood & Emotions' do
    click_on 'Tracking Your Mood & Emotions'
    expect(page).to have_content 'Rate your Mood'

    select '6', from: 'mood[rating]'
    click_on 'Next'
    expect(page).to have_content 'Mood saved'

    expect(page).to have_content 'You just rated your mood as a 6 (Good)'

    expect(page).to have_content 'Rate your Emotions'

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

    expect(page).to have_content 'Mood'

    expect(page).to have_content 'Positive and Negative Emotions'

    today = Date.today
    one_week_ago = today - 6
    one_month_ago = today - 27
    expect(page).to have_content one_week_ago.strftime('%B %e, %Y') + ' / ' \
                                 + today.strftime('%B %e, %Y')

    find('.btn.btn-default', text: '28 day').click
    expect(page).to have_content one_month_ago.strftime('%B %e, %Y') + ' / ' \
                                 + today.strftime('%B %e, %Y')

    find('.btn.btn-default', text: '7 Day').click
    click_on 'Previous Period'
    one_week_ago_1 = today - 7
    two_weeks_ago = today - 13
    expect(page).to have_content two_weeks_ago.strftime('%B %e, %Y') + ' / ' \
                                 + one_week_ago_1.strftime('%B %e, %Y')

    click_on 'Next'
    expect(page).to have_content 'Feeling Tracker Landing'
  end

  it 'views recent ratings in Your Recent Mood & Emtions' do
    click_on 'Your Recent Moods & Emotions'
    expect(page).to have_content 'Mood'

    expect(page).to have_content 'Positive and Negative Emotions'

    click_on 'Next'
    expect(page).to have_content 'Feeling Tracker Landing'
  end

  it 'uses navbar functionality in all of FEEL' do
    visit ENV['Base_URL'] + '/navigator/modules/86966983'
    click_on 'FEEL'
    click_on 'Your Recent Moods & Emotions'
    expect(page).to have_content 'Mood'

    expect(page).to have_content 'Positive and Negative Emotions'

    click_on 'FEEL'
    click_on 'Tracking Your Mood & Emotions'
    expect(page).to have_content 'Rate your Mood'

    click_on 'FEEL'
    click_on 'FEEL Home'
    expect(page).to have_content 'Feeling Tracker Landing'
  end
end
