# filename: user_bugs_spec.rb

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

describe 'User Dashboard Bugs', type: :feature, sauce: sauce_labs do
  before(:each) do
    visit ENV['Base_URL'] + '/users/sign_in'
    within('#new_user') do
      fill_in 'user_email', with: ENV['User_Email']
      fill_in 'user_password', with: ENV['User_Password']
    end

    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'
  end

  # tests
  it 'Researcher signs in, creates a participant, assigns a group membership and sees corret calculation of end date' do
    click_on 'Participants'
    expect(page).to have_content 'Participants'
    click_on 'New'
    expect(page).to have_content 'New Participant'

    fill_in 'participant_study_id', with: 'Tests'
    fill_in 'participant_email', with: 'test@test.com'
    fill_in 'participant_phone_number', with: ENV['Participant_Phone_Number']
    select 'Email', from: 'participant_contact_preference'
    click_on 'Create'
    expect(page).to have_content 'Participant was successfully created.'

    click_on 'Assign New Group'
    expect(page).to have_content 'Assigning New Group to Participant'

    select 'Group 1', from: 'membership_group_id'
    yesterday = Date.today.prev_day
    fill_in 'membership_start_date', with: yesterday.strftime('%Y-%m-%d')
    today = Date.today
    next_year = today + 365
    fill_in 'membership_end_date', with: next_year.strftime('%Y-%m-%d')
    weeks_later = today + 56
    expect(page).to have_content 'Standard number of weeks: 8, Projected End Date from today: ' + weeks_later.strftime('%-m/%-d/%Y')

    click_on 'Assign'
    expect(page).to have_content 'Group was successfully assigned'

    expect(page).to have_content 'Study Id: Tests'

    expect(page).to have_content 'Group: Group 1'

    expect(page).to have_content 'Membership Status: Active'
  end
end
