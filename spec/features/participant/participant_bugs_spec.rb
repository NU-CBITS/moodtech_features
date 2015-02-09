# filename: participant_bugs_spec.rb

# this file is to test bug fixes

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

describe 'Participant Bugs', type: :feature, sauce: sauce_labs do
  before(:each) do
    visit ENV['Base_URL'] + '/participants/sign_in'
    within('#new_participant') do
      fill_in 'participant_email', with: ENV['Participant_Email']
      fill_in 'participant_password', with: ENV['Participant_Password']
    end
    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
  end

  # tests
  # Testing bug where I am receiving multiple alerts in the Planning form.
  it '- planning bug where there are multiple alerts' do
    visit ENV['Base_URL'] + '/navigator/contexts/DO'
    expect(page).to have_content 'Add a New Activity'

    click_on '#2 Planning'
    expect(page).to have_content 'The last few times you were here...'

    click_on 'Next'
    expect(page).to have_content 'We want you to plan one fun thing'

    fill_in 'activity_activity_type_new_title', with: 'New planned activity'
    today = Date.today
    tomorrow = today + 1
    fill_in 'future_date_picker_0', with: tomorrow.strftime('%d %b, %Y')
    choose_rating('pleasure_0', 6)
    choose_rating('accomplishment_0', 3)
    click_on 'Next'
    page.accept_alert 'Are you sure that you would like to make these public?'
    expect(page).to have_content 'Activity saved'

    expect(page).to have_content 'Now, plan something that gives you a sense of accomplishment.'

    fill_in 'activity_activity_type_new_title', with: 'Another planned activity'
    today = Date.today
    tomorrow = today + 1
    fill_in 'future_date_picker_0', with: tomorrow.strftime('%d %b, %Y')
    choose_rating('pleasure_0', 4)
    choose_rating('accomplishment_0', 8)
    click_on 'Next'
    page.accept_alert 'Are you sure that you would like to make these public?'
    expect(page).to have_content 'Activity saved'

    expect(page).to have_content 'OK... the most important thing is to do more that is pleasureable and gives you a sense of accomplishment'

    click_on 'Next'
    expect(page).to have_content 'Your Planned Activities'

    click_on 'Next'
    expect(page).to have_content 'Upcoming Activities'
  end

  # Testing bug where I am receiving multiple alerts in the Plan a New Activity Form
  it '- plan a new activity' do
    visit ENV['Base_URL'] + '/navigator/contexts/DO'
    expect(page).to have_content 'Add a New Activity'

    click_on 'Add a New Activity'
    expect(page).to have_content "But you don't have to start from scratch,"

    fill_in 'activity_activity_type_new_title', with: 'New planned activity'
    today = Date.today
    tomorrow = today + 1
    fill_in 'future_date_picker_0', with: tomorrow.strftime('%d %b, %Y')
    choose_rating('pleasure_0', 4)
    choose_rating('accomplishment_0', 3)
    click_on 'Next'
    page.accept_alert 'Are you sure that you would like to make these public?'
    expect(page).to have_content 'Activity saved'

    expect(page).to have_content 'Add a New Activity'
  end
end
