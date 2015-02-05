# filename: goals_spec.rb

require_relative '../../../../spec/spec_helper'
require_relative '../../../../spec/configure_cloud'

describe 'Goals', type: :feature, sauce: sauce_labs do
  before(:each) do
    visit ENV['Base_URL'] + '/participants/sign_in'
    within('#new_participant') do
      fill_in 'participant_email', with: ENV['Participant_Email']
      fill_in 'participant_password', with: ENV['Participant_Password']
    end

    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'

    visit ENV['Base_URL'] + '/social_networking/goal_tool'
    expect(page).to have_content 'add a goal'
  end

  # tests
  it '- create a goal' do
    click_on '+ add a goal'
    expect(page).to have_content 'What is your goal?'

    fill_in 'new-goal-description', with: 'eat a whole pizza'
    choose '8 weeks (end of study)'
    click_on 'Save'
    expect(page).to have_content '+ add a goal'

    expect(page).to have_content 'eat a whole pizza'

    visit ENV['Base_URL']
    expect(page).to have_content 'created a Goal: eat a whole pizza'

    find(:xpath, '//*[@id="SocialNetworking::SharedItem-809335069"]/div[2]/button[5]').click
    today = Date.today
    end_of_study = today + 4
    expect(page).to have_content 'due ' + end_of_study.strftime('%b. %e, %Y') + ' at 12:00AM'
  end

  it '- complete a goal' do
    find(:xpath, '//*[@id="goal-809335042"]/div/button[1]/span/i').click
    click_on 'Completed'
    expect(page).to_not have_content 'p1 gamma'

    expect(page).to have_content 'p1 alpha'

    visit ENV['Base_URL']
    expect(page).to have_content 'completed a Goal: p1 alpha'
  end

  it '- delete a goal' do
    find(:xpath, '//*[@id="goal-614371357"]/div/button[3]/i').click
    expect(page).to_not have_content 'p1 gamma'

    click_on 'Deleted'
    expect(page).to_not have_content 'p1 alpha'

    expect(page).to have_content 'p1 gamma'
  end

  it '- reinstate a previously deleted goal' do
    click_on 'Deleted'
    expect(page).to have_content 'p1 delta'

    find(:xpath, '//*[@id="goal-916373174"]/div/button/i').click
    expect(page).to_not have_content 'p1 delta'

    click_on 'All'
    expect(page).to have_content 'p1 delta'
  end
end
