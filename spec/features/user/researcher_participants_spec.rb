# filename: researcher_participants_spec.rb

require_relative '../../../spec/spec_helper'
require_relative '../../../spec/configure_cloud'

describe 'Research, Participants', type: :feature, sauce: sauce_labs do
  before(:each) do
    visit ENV['Base_URL'] + '/users/sign_in'
    within('#new_user') do
      fill_in 'user_email', with: ENV['Researcher_Email']
      fill_in 'user_password', with: ENV['Researcher_Password']
    end

    click_on 'Sign in'
    expect(page).to have_content 'Signed in successfully'

    expect(page).to have_content 'CSV Reports'

    click_on 'Participants'
    expect(page).to have_content 'Listing Participants'
  end

  # tests
  # Testing creating a participant
  it '- create a participant' do
    click_on 'New'
    expect(page).to have_content 'New Participant'

    fill_in 'participant_study_id', with: 'Tests'
    fill_in 'participant_email', with: 'test@test.com'
    fill_in 'participant_phone_number', with: ENV['Participant_Phone_Number']
    select 'Email', from: 'participant_contact_preference'
    click_on 'Create'
    expect(page).to have_content 'Participant was successfully created.'

    expect(page).to have_content 'Study Id: Tests'

    expect(page).to have_content 'Email: test@test.com'

    expect(page).to have_content 'Phone Number: ' + ENV['Participant_Phone_Number_1']

    expect(page).to have_content 'Contact Preference: Email'
  end

  # Testing updating a participant
  it '- updating a participant' do
    click_on 'TFD-1111'
    expect(page).to have_content 'Study Id: TFD-1111'

    click_on 'Edit'
    expect(page).to have_content 'Editing Participant'

    fill_in 'participant_study_id', with: 'Updated TFD-1111'
    fill_in 'participant_email', with: 'updatedfake@test.com'
    fill_in 'participant_phone_number', with: ENV['Participant_Phone_Number']
    click_on 'Update'
    expect(page).to have_content 'Participant was successfully updated.'

    expect(page).to have_content 'Study Id: Updated TFD-1111'

    expect(page).to have_content 'Email: updatedfake@test.com'

    expect(page).to have_content 'Phone Number: ' + ENV['Participant_Phone_Number_1']

    expect(page).to have_content 'Contact Preference: Email'

    click_on 'Edit'
    expect(page).to have_content 'Editing Participant'

    fill_in 'participant_study_id', with: 'TFD-1111'
    fill_in 'participant_email', with: ENV['Participant_Email']
    fill_in 'participant_phone_number', with: ENV['Participant_Phone_Number']
    click_on 'Update'
    expect(page).to have_content 'Participant was successfully updated.'

    expect(page).to have_content 'Study Id: TFD-1111'

    expect(page).to have_content 'Email: ' + ENV['Participant_Email']

    expect(page).to have_content 'Phone Number: ' + ENV['Participant_Phone_Number_1']

    expect(page).to have_content 'Contact Preference: Email'
  end

  # Testing assigning a coach
  it '- assign a coach' do
    click_on 'Tests'
    expect(page).to have_content 'Study Id: Tests'
    click_on 'Assign Coach'
    expect(page).to have_content 'Assigning Coach to Participant'
    select ENV['User_Email'], from: 'coach_assignment_coach_id'
    click_on 'Assign'
    expect(page).to have_content 'Coach was successfully assigned.'
    expect(page).to have_content 'Study Id: Tests'
    expect(page).to have_content 'Coach: ' + ENV['User_Email']
  end

  # Testing creating a group membership
  it '- create a group membership' do
    click_on 'Tests'
    expect(page).to have_content 'Study Id: Tests'

    click_on 'Assign New Group'
    expect(page).to have_content 'Assigning New Group to Participant'

    select 'Group 1', from: 'membership_group_id'
    yesterday = Date.today.prev_day
    fill_in 'membership_start_date', with: yesterday.strftime('%Y-%m-%d')
    today = Date.today
    next_year = today + 365
    fill_in 'membership_end_date', with: next_year.strftime('%Y-%m-%d')
    click_on 'Assign'
    expect(page).to have_content 'Group was successfully assigned'

    expect(page).to have_content 'Study Id: Tests'

    expect(page).to have_content 'Group: Group 1'

    expect(page).to have_content 'Membership Status: Active'
  end

  # Testing destroying a participant
  it '- destroy a participant' do
    click_on 'Tests'
    expect(page).to have_content 'Study Id: Tests
    '
    click_on 'Destroy'
    page.accept_alert 'Are you sure?'
    expect(page).to have_content 'Participant was successfully destroyed.'

    expect(page).to_not have_content 'Tests'
  end
end
